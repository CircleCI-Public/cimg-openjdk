import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest


REPOSITORY = Path(__file__).resolve().parents[1]


class TemurinReleaseTest(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.directory = Path(temporary.name)

    def test_shared_commands_receive_an_empty_pin_for_each_unpinned_version(self):
        shutil.copy(REPOSITORY / "temurin-release.sh", self.directory)
        shared = self.directory / "shared"
        shared.mkdir()
        for mode, script in (("generate", "gen-dockerfiles.sh"), ("release", "release.sh")):
            with self.subTest(mode=mode):
                stub = shared / script
                stub.write_text('#!/usr/bin/env bash\nprintf "%s\\n" "${0##*/}" "$@"\n')
                stub.chmod(0o755)
                versions = ["25.0.5.1#jdk-25.0.5.1+2", "21.0.13", "17.0.21=lts"]
                result = subprocess.run(["bash", "temurin-release.sh", mode, *versions],
                                        cwd=self.directory, text=True, capture_output=True, check=True)
                self.assertEqual(result.stdout.splitlines(),
                                 [script, versions[0], "21.0.13#", "17.0.21=lts#"])

    def resolve(self, version, pinned_tag, response):
        template = (REPOSITORY / "Dockerfile.template").read_text()
        recipe = template.split("RUN [[ $(uname -m)", 1)[1]
        recipe = recipe.split('\tcurl -fsSL -o java.tar.gz', 1)[0]
        recipe = re.sub(r"\\\n", " ", "[[ $(uname -m)" + recipe)
        (self.directory / "release.json").write_text(json.dumps(response))
        requests = self.directory / "requests"
        requests.write_text("")
        cli = '''
uname() { printf 'x86_64\\n'; }
curl() { printf '%s\\n' "${!#}" >> requests; cat release.json; }
'''
        result = subprocess.run(["bash", "-e", "-o", "pipefail", "-c", cli + recipe + 'printf "%s\\n" "$URL"'],
                                cwd=self.directory, text=True, capture_output=True,
                                env=dict(os.environ, JAVA_VERSION=version, TEMURIN_RELEASE_TAG=pinned_tag))
        return result, requests.read_text().splitlines()

    def release(self, tag):
        return {
            "tag_name": tag, "draft": False, "prerelease": False,
            "assets": [
                {"state": "uploaded", "name": f"OpenJDK25U-jdk_{arch}_linux_hotspot_fixture.tar.gz",
                 "browser_download_url": f"https://example.test/{tag}/{arch}"}
                for arch in ("x64", "aarch64")
            ],
        }

    def test_invalid_explicit_pin_fails_before_network_access(self):
        for version, pin in (("25.0.5", "jdk-25.0.6+9"), ("25.0.5", "jdk-25.0.5+8-beta"),
                             ("8.0.514", "jdk8u514-b01")):
            with self.subTest(version=version, pin=pin):
                result, requests = self.resolve(version, pin, [])
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("TEMURIN_RELEASE_TAG", result.stderr)
                self.assertEqual(requests, [])

    def test_explicit_pin_uses_exact_tag_and_checks_the_response(self):
        for version, tag in (("25.0", "jdk-25+36"), ("25.0.0", "jdk-25+36"),
                             ("25.0.5.1", "jdk-25.0.5.1+2"),
                             ("25.0.5.0.2", "jdk-25.0.5.0.2+9.1")):
            with self.subTest(version=version):
                result, requests = self.resolve(version, tag, self.release(tag))
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stdout.strip(), f"https://example.test/{tag}/x64")
                self.assertTrue(requests[0].endswith("/tags/" + tag.replace("+", "%2B")))
        result, _ = self.resolve("25.0.5.1", "jdk-25.0.5.1+2", self.release("jdk-25.0.5.1+3"))
        self.assertNotEqual(result.returncode, 0)

    def test_no_pin_uses_stable_release_lookup(self):
        releases = [self.release("jdk-25.0.5+8"), self.release("jdk-25.0.5+9")]
        result, requests = self.resolve("25.0.5", "", releases)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout.strip(), "https://example.test/jdk-25.0.5+9/x64")
        self.assertTrue(requests[0].endswith("/releases"))

#!/usr/bin/env python3
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import unittest


VERSION = "25.0.8"
VARIANTS = ("", "-node", "-browsers")
PARENT_LABEL = "com.circleci.release-parent"
VERSION_LABEL = "com.circleci.release-version"


def register_image(state, tag, labels):
    digest = f"sha256:{len(state['images']) + 1:064x}"
    state["images"][digest] = labels
    state["tags"][tag] = digest
    return digest


def run_registry_fixture(tool, args):
    path = Path(os.environ["RELEASE_TEST_REGISTRY"])
    state = json.loads(path.read_text())
    tags = state["tags"]

    if tool == "regctl":
        group, command, ref, *options = args
        if group == "tag" and command == "ls":
            if ref == state.get("fail_tag_listing"):
                return 1
            pattern = options[options.index("--include") + 1]
            for tagged_ref in tags:
                repository, tag = tagged_ref.rsplit(":", 1)
                if repository == ref and re.fullmatch(pattern, tag):
                    print(tag)
        elif command == "digest":
            reads_before_error = state.get("digest_reads_before_error", {})
            if ref in reads_before_error:
                if reads_before_error[ref] == 0:
                    return 1
                reads_before_error[ref] -= 1
            if ref not in tags:
                return 1
            print(tags[ref])
        elif command == "config":
            digest = ref.split("@")[1]
            labels = state["images"][digest]
            assert options[-1] == "{{json .Config}}"
            if ref == state.get("fail_version_lookup"):
                return 1
            print(json.dumps({"Labels": labels, "Env": state.get("envs", {}).get(digest, [])}))
        elif command == "copy":
            assert ref.startswith("ccitest/openjdk@sha256:"), ref
            if options[0] == state.get("fail_copy"):
                return 1
            state.setdefault("copies", []).append(options[0])
            tags[options[0]] = ref.split("@")[1]
        else:
            raise AssertionError(args)
    elif args[0] == "login":
        sys.stdin.read()
    elif args[:2] == ["buildx", "build"]:
        tag = args[args.index("-t") + 1]
        labels = dict(arg.split("=", 1) for flag, arg in zip(args, args[1:]) if flag == "--label")
        if tag.endswith(("-node", "-browsers")):
            dockerfile = Path(args[args.index("--file") + 1]).read_text()
            parent = args[args.index("--build-arg") + 1].split("=", 1)[1]
            assert "FROM ${RELEASE_PARENT}" in dockerfile
            assert parent.split("@")[1] == labels[PARENT_LABEL]
            assert labels[PARENT_LABEL] in state["images"]
        digest = register_image(state, tag, labels)
        state["builds"].append(tag)
        metadata = Path(args[args.index("--metadata-file") + 1])
        metadata.write_text(json.dumps({"containerimage.digest": digest}))
        # Simulate a Test job replacing the mutable staging Node tag.
        if state.get("retag_node_after") and tag.endswith(state["retag_node_after"]):
            node_tag = tag.rsplit("-", 1)[0] + "-node"
            register_image(state, node_tag, state["images"][tags[node_tag]])
    else:
        raise AssertionError(args)

    path.write_text(json.dumps(state))
    return 0


class ReleasePublicationTest(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        self.repo = Path(directory.name)
        self.state_file = self.repo / "registry.json"
        self.write_state({"tags": {}, "images": {}, "builds": []})
        tools = self.repo / "bin"
        tools.mkdir()
        fixture = tools / "fixture"
        shutil.copyfile(__file__, fixture)
        fixture.chmod(0o755)
        for tool in ("docker", "regctl"):
            (tools / tool).symlink_to(fixture)
        self.env = dict(os.environ, PATH=f"{tools}:{os.environ['PATH']}",
                        RELEASE_TEST_REGISTRY=str(self.state_file), DOCKER_USER="fixture", DOCKER_TOKEN="fixture")
        self.run_command("git", "init", "-q", "-b", "main")
        self.run_command("git", "config", "user.name", "Release Fixture")
        self.run_command("git", "config", "user.email", "fixture@example.test")
        source = Path(__file__).resolve().parents[1]
        shutil.copytree(source / ".circleci", self.repo / ".circleci")
        shutil.copyfile(source / "manifest", self.repo / "manifest")
        self.write_release_files(VERSION, "", VARIANTS)
        self.run_command("git", "add", "25.0", "manifest", ".circleci", "build-images.sh")
        self.run_command("git", "commit", "-qm", f"Publish {VERSION} [release]")
        self.tree = self.run_command("git", "rev-parse", "HEAD:25.0").stdout.strip()

    def write_release_files(self, version, pin, variants):
        commands = ["#!/usr/bin/env bash", "set -eo pipefail"]
        for suffix in variants:
            directory = self.repo / "25.0" / suffix.lstrip("-")
            directory.mkdir(parents=True, exist_ok=True)
            parent = "-node" if suffix == "-browsers" else ""
            dockerfile = directory / "Dockerfile"
            dockerfile.write_text(f"FROM cimg/openjdk:{version}{parent}\n" if suffix else
                                  f"FROM cimg/base:current\nENV JAVA_VERSION={version}\nARG TEMURIN_RELEASE_TAG={pin}\n")
            commands.append(f"docker buildx build --platform=linux/amd64 --file {dockerfile.relative_to(self.repo)}"
                            f" -t cimg/openjdk:{version}{suffix} -t cimg/openjdk:25.0{suffix} --push .")
        (self.repo / "build-images.sh").write_text("\n".join(commands) + "\n")

    def merge_release(self, version, pin="", variants=("",)):
        self.write_release_files(version, pin, variants)
        self.run_command("git", "add", "25.0", "build-images.sh")
        self.run_command("git", "commit", "--allow-empty", "-qm", f"Publish {version} [release]")
        self.tree = self.run_command("git", "rev-parse", "HEAD:25.0").stdout.strip()

    def run_command(self, *command, check=True):
        result = subprocess.run(command, cwd=self.repo, env=self.env, text=True, capture_output=True)
        if check:
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        return result

    def write_state(self, state):
        self.state_file.write_text(json.dumps(state))

    def read_state(self):
        return json.loads(self.state_file.read_text())

    def stage(self):
        self.run_command("bash", ".circleci/prepare-release.sh")
        # The cimg orb performs this namespace replacement on Test builds.
        instructions = (self.repo / "build-images.sh").read_text().replace("cimg", "ccitest")
        self.run_command("bash", "-c", instructions)
        self.run_command("git", "restore", "25.0", "build-images.sh")

    def deploy(self, check=True):
        return self.run_command("bash", ".circleci/publish-release.sh", check=check)

    def stage_ref(self, variant):
        return f"ccitest/openjdk:stage-{self.tree}{variant}"

    def assert_public_family(self, state, version, build_version):
        tags = state["tags"]
        base, node, browsers = (tags[f"cimg/openjdk:{version}{variant}"] for variant in VARIANTS)
        self.assertEqual(state["images"][node][PARENT_LABEL], base)
        self.assertEqual(state["images"][browsers][PARENT_LABEL], node)
        for digest in (base, node, browsers):
            self.assertEqual(state["images"][digest][VERSION_LABEL], build_version)

    def test_non_release_commit_never_promotes_previous_release(self):
        self.stage()
        self.run_command("git", "commit", "--allow-empty", "-qm", "Update docs", "-m", "Mention [release]")
        self.deploy()
        self.assertFalse(self.read_state().get("copies"))

    def test_only_checked_out_release_is_published_and_patch_aliases_are_added(self):
        self.stage()
        self.merge_release("25.0.5.1", "jdk-25.0.5.1+2", VARIANTS)
        self.stage()
        # Moving main beyond the checked-out release must not affect publication.
        release = self.run_command("git", "rev-parse", "HEAD").stdout.strip()
        self.merge_release("25.0.6", "jdk-25.0.6+3", VARIANTS)
        self.stage()
        self.run_command("git", "checkout", "--detach", release)
        self.deploy()
        state = self.read_state()
        self.assert_public_family(state, "25.0.5.1", "25.0.5.1+2")
        for variant in VARIANTS:
            exact = state["tags"][f"cimg/openjdk:25.0.5.1{variant}"]
            for alias in ("25.0.5", "25.0"):
                self.assertEqual(state["tags"][f"cimg/openjdk:{alias}{variant}"], exact)
            for other_release in (VERSION, "25.0.6"):
                self.assertNotIn(f"cimg/openjdk:{other_release}{variant}", state["tags"])

    def test_retained_legacy_base_defers_old_variant_aliases(self):
        self.merge_release("25.0.5.1", "jdk-25.0.5.1+2", VARIANTS)
        self.stage()
        state = self.read_state()
        base_tag = "cimg/openjdk:25.0"
        current = register_image(state, base_tag, {})
        state["envs"] = {current: ["JAVA_VERSION=25.0.6"]}
        self.write_state(state)
        self.deploy()
        state = self.read_state()
        self.assertEqual(state["tags"][base_tag], current)
        self.assertNotIn(base_tag + "-node", state["tags"])
        self.assertNotIn(base_tag + "-browsers", state["tags"])
        self.assert_public_family(state, "25.0.5.1", "25.0.5.1+2")
        self.assert_public_family(state, "25.0.5", "25.0.5.1+2")

    def test_same_ga_spelling_cannot_roll_back_a_known_build(self):
        self.merge_release("25.0", "jdk-25+35", VARIANTS)
        self.stage()
        state = self.read_state()
        for variant in VARIANTS:
            register_image(state, f"cimg/openjdk:25.0{variant}", {VERSION_LABEL: "25.0+36"})
        expected = state["tags"].copy()
        self.write_state(state)
        self.deploy()
        self.assertEqual(self.read_state()["tags"], expected)

    def test_ga_spellings_compare_build_numbers_and_equal_build_can_update(self):
        self.merge_release("25.0.0", "jdk-25+35", VARIANTS)
        self.stage()
        state = self.read_state()
        for variant in VARIANTS:
            register_image(state, f"cimg/openjdk:25.0{variant}", {VERSION_LABEL: "25.0+35"})
        self.write_state(state)
        self.deploy()
        self.assert_public_family(self.read_state(), "25.0", "25.0.0+35")

    def test_missing_staging_image_leaves_production_untouched(self):
        self.stage()
        state = self.read_state()
        del state["tags"][self.stage_ref("-browsers")]
        expected = state["tags"].copy()
        self.write_state(state)
        result = self.deploy(check=False)
        self.assertEqual(result.returncode, 1)
        self.assertIn("Missing or unreadable staging image", result.stderr)
        self.assertEqual(self.read_state()["tags"], expected)
        self.assertEqual(self.read_state()["builds"], state["builds"])

    def test_mismatched_staged_parent_leaves_production_untouched(self):
        state = self.read_state()
        state["retag_node_after"] = "-node"
        self.write_state(state)
        self.stage()
        result = self.deploy(check=False)
        self.assertEqual(result.returncode, 1)
        self.assertIn("parent digest does not match", result.stderr)
        self.assertFalse(self.read_state().get("copies"))

    def test_inconclusive_registry_lookup_leaves_production_untouched(self):
        self.stage()
        state = self.read_state()
        exact = f"cimg/openjdk:{VERSION}"
        register_image(state, exact, {VERSION_LABEL: VERSION})
        state["digest_reads_before_error"] = {exact: 0}
        expected = state["tags"].copy()
        self.write_state(state)
        result = self.deploy(check=False)
        self.assertEqual(result.returncode, 1)
        self.assertIn("Unable to determine digest", result.stderr)
        self.assertEqual(self.read_state()["tags"], expected)

    def test_failed_copy_can_be_retried_without_republishing_the_base(self):
        self.stage()
        state = self.read_state()
        state["fail_copy"] = f"cimg/openjdk:{VERSION}-node"
        self.write_state(state)
        self.assertEqual(self.deploy(check=False).returncode, 1)
        state = self.read_state()
        self.assertNotIn(f"cimg/openjdk:{VERSION}-browsers", state["tags"])
        self.assertEqual(state["copies"], [f"cimg/openjdk:{VERSION}", "cimg/openjdk:25.0"])
        del state["fail_copy"]
        self.write_state(state)
        self.deploy()
        state = self.read_state()
        self.assert_public_family(state, VERSION, VERSION)
        self.assertEqual(state["copies"].count(f"cimg/openjdk:{VERSION}"), 1)
if __name__ == "__main__":
    tool = Path(sys.argv[0]).name
    if tool in {"docker", "regctl"}:
        sys.exit(run_registry_fixture(tool, sys.argv[1:]))
    unittest.main()

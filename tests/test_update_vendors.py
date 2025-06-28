import os
import subprocess
from pathlib import Path


def test_update_vendors_prunes_obsolete_submodule(tmp_path):
    repo_root = Path(__file__).resolve().parents[1]
    scripts_dir = repo_root / "scripts"
    tmp_scripts = tmp_path / "scripts"
    tmp_scripts.mkdir()
    (tmp_scripts / "update_vendors.sh").write_text((scripts_dir / "update_vendors.sh").read_text())

    subprocess.run(["git", "init"], cwd=tmp_path, check=True)

    dummy_repo = tmp_path / "dummy_repo"
    dummy_repo.mkdir()
    subprocess.run(["git", "init"], cwd=dummy_repo, check=True)
    (dummy_repo / "README.md").write_text("dummy")
    subprocess.run(["git", "add", "README.md"], cwd=dummy_repo, check=True)
    subprocess.run(["git", "commit", "-m", "init"], cwd=dummy_repo, check=True)

    env = {**os.environ, "GIT_ALLOW_PROTOCOL": "file"}
    subprocess.run([
        "git",
        "submodule",
        "add",
        str(dummy_repo),
        "vendor/dummy",
    ], cwd=tmp_path, check=True, env=env)
    subprocess.run(["git", "commit", "-am", "add submodule"], cwd=tmp_path, check=True)

    assert (tmp_path / "vendor" / "dummy").exists()

    (tmp_path / "apps.json").write_text("{}")
    (tmp_path / "custom_vendors.json").write_text("{}")

    subprocess.run(["bash", str(tmp_scripts / "update_vendors.sh")], cwd=tmp_path, check=True)

    assert not (tmp_path / "vendor" / "dummy").exists()
    gitmodules = tmp_path / ".gitmodules"
    if gitmodules.exists():
        assert "vendor/dummy" not in gitmodules.read_text()

    assert (tmp_path / "apps.json").read_text().strip() == "{}"


def test_update_vendors_rebuilds_configs(tmp_path):
    repo_root = Path(__file__).resolve().parents[1]
    scripts_dir = repo_root / "scripts"
    tmp_scripts = tmp_path / "scripts"
    tmp_scripts.mkdir()
    (tmp_scripts / "update_vendors.sh").write_text((scripts_dir / "update_vendors.sh").read_text())

    subprocess.run(["git", "init"], cwd=tmp_path, check=True)

    # create dummy repos for custom apps
    app1_repo = tmp_path / "app1_repo"
    app1_repo.mkdir()
    subprocess.run(["git", "init"], cwd=app1_repo, check=True)
    (app1_repo / "README.md").write_text("a1")
    subprocess.run(["git", "add", "README.md"], cwd=app1_repo, check=True)
    subprocess.run(["git", "commit", "-m", "init"], cwd=app1_repo, check=True)

    app2_repo = tmp_path / "app2_repo"
    app2_repo.mkdir()
    subprocess.run(["git", "init"], cwd=app2_repo, check=True)
    (app2_repo / "README.md").write_text("a2")
    subprocess.run(["git", "add", "README.md"], cwd=app2_repo, check=True)
    subprocess.run(["git", "commit", "-m", "init"], cwd=app2_repo, check=True)

    # root config has outdated apps.json which should be ignored
    (tmp_path / "apps.json").write_text("{\n  \"oldapp\": {\"repo\": \"file://old\", \"branch\": \"main\"}\n}")

    (tmp_path / "custom_vendors.json").write_text(
        "{\n  \"app1\": {\"repo\": \"" + str(app1_repo) + "\", \"tag\": \"v1\"}}"
    )

    template_dir = tmp_path / "demo-template"
    template_dir.mkdir()
    (template_dir / "custom_vendors.json").write_text(
        "{\n  \"app2\": {\"repo\": \"" + str(app2_repo) + "\", \"tag\": \"v2\"}}"
    )

    env = {**os.environ, "GIT_ALLOW_PROTOCOL": "file"}
    subprocess.run(["bash", str(tmp_scripts / "update_vendors.sh")], cwd=tmp_path, check=True, env=env)

    data = (tmp_path / "apps.json").read_text()
    assert "oldapp" not in data
    custom = (tmp_path / "custom_vendors.json").read_text()
    assert "app1" in custom and "app2" in custom

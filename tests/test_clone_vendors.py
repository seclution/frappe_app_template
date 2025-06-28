import os
import subprocess
from pathlib import Path


def test_clone_vendors_prunes_obsolete_submodule(tmp_path):
    repo_root = Path(__file__).resolve().parents[1]
    scripts_dir = repo_root / "scripts"
    tmp_scripts = tmp_path / "scripts"
    tmp_scripts.mkdir()
    (tmp_scripts / "clone_vendors.sh").write_text((scripts_dir / "clone_vendors.sh").read_text())

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

    subprocess.run(["bash", str(tmp_scripts / "clone_vendors.sh")], cwd=tmp_path, check=True)

    assert not (tmp_path / "vendor" / "dummy").exists()
    gitmodules = tmp_path / ".gitmodules"
    if gitmodules.exists():
        assert "vendor/dummy" not in gitmodules.read_text()

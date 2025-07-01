import subprocess
from pathlib import Path


def test_setup_script_creates_app(tmp_path):
    repo_root = Path(__file__).resolve().parents[1]
    script_path = repo_root / "setup.sh"
    tmp_script = tmp_path / "setup.sh"
    tmp_script.write_text(script_path.read_text())
    tmp_script.chmod(0o755)

    # minimal required config files
    (tmp_path / "vendors.txt").write_text((repo_root / "vendors.txt").read_text())
    (tmp_path / "apps.json").write_text((repo_root / "apps.json").read_text())

    subprocess.run(["git", "init"], cwd=tmp_path, check=True)
    subprocess.run([str(tmp_script), "demoapp"], cwd=tmp_path, check=True)

    assert (tmp_path / "app" / "demoapp").is_dir()
    assert (tmp_path / "app" / "setup.py").exists()
    assert not (tmp_path / "setup.py").exists()

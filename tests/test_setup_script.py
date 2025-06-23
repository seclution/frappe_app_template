import subprocess
from pathlib import Path
import shutil


def prepare_repo(tmp_path: Path):
    main = tmp_path / "main"
    main.mkdir()
    subprocess.run(["git", "init"], cwd=main, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    sub = main / "template"
    sub.mkdir()
    subprocess.run(["git", "init"], cwd=sub, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    repo_root = Path(__file__).resolve().parent.parent
    shutil.copy(repo_root / "setup.sh", sub / "setup.sh")
    (sub / ".github" / "workflows").mkdir(parents=True)
    for wf in (repo_root / ".github" / "workflows").glob("*.yml"):
        shutil.copy(wf, sub / ".github" / "workflows" / wf.name)

    return main, sub


def test_setup_copies_workflows_and_creates_files(tmp_path):
    main, sub = prepare_repo(tmp_path)

    subprocess.run(["bash", str(sub / "setup.sh")], cwd=sub, check=True)

    workflows = [
        "ci.yml",
        "update-vendor.yml",
        "clone-templates.yml",
        "clone-vendors.yml",
        "create-app-repo.yml",
        "publish.yml",
    ]
    for wf in workflows:
        assert (main / ".github" / "workflows" / wf).exists()

    assert (main / "custom_vendors.json").exists()
    assert (main / "templates.txt").exists()
    assert (main / "sample_data").is_dir()

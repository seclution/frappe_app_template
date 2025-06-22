import json
import subprocess
from pathlib import Path
import shutil


def run_setup(script: Path, tmpdir: Path):
    subprocess.run(["git", "init"], cwd=tmpdir, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (tmpdir / "apps").mkdir()
    (tmpdir / "vendor" / "myapp" / "instructions").mkdir(parents=True)
    (tmpdir / "instructions").mkdir()
    (tmpdir / "sample_data").mkdir()
    subprocess.run(["bash", str(script)], cwd=tmpdir, check=True)
    with open(tmpdir / "codex.json") as f:
        data = json.load(f)
    return data["sources"]


def test_setup_creates_expected_codex_json(tmp_path):
    script = Path(__file__).resolve().parent.parent / "setup.sh"
    sources = run_setup(script, tmp_path)
    assert sources == [
        "apps/",
        "vendor/myapp/",
        "vendor/myapp/instructions/",
        "instructions/",
        "sample_data/",
    ]


def test_setup_copies_workflows_to_parent(tmp_path):
    main_repo = tmp_path / "main"
    main_repo.mkdir()
    subprocess.run(["git", "init"], cwd=main_repo, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    sub = main_repo / "template"
    sub.mkdir()
    subprocess.run(["git", "init"], cwd=sub, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    repo_root = Path(__file__).resolve().parent.parent
    shutil.copy(repo_root / "setup.sh", sub / "setup.sh")
    (sub / "scripts").mkdir()
    shutil.copy(repo_root / "scripts" / "common_setup.sh", sub / "scripts" / "common_setup.sh")
    workflows_src = repo_root / ".github" / "workflows"
    (sub / ".github" / "workflows").mkdir(parents=True)
    for wf in workflows_src.glob("*.yml"):
        shutil.copy(wf, sub / ".github" / "workflows" / wf.name)

    (sub / "apps").mkdir()
    (sub / "vendor" / "myapp" / "instructions").mkdir(parents=True)
    (sub / "instructions").mkdir()
    (sub / "sample_data").mkdir()

    subprocess.run(["bash", str(sub / "setup.sh")], cwd=sub, check=True)

    assert (main_repo / ".github" / "workflows" / "ci.yml").exists()
    assert (main_repo / ".github" / "workflows" / "update-vendor.yml").exists()


import json
import subprocess
from pathlib import Path


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


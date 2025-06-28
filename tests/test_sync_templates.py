import json
import subprocess
from pathlib import Path


def test_sync_templates_removes_deleted(tmp_path):
    scripts_dir = Path(__file__).resolve().parents[1] / "scripts"
    tmp_scripts = tmp_path / "scripts"
    tmp_scripts.mkdir()
    (tmp_scripts / "sync_templates.sh").write_text((scripts_dir / "sync_templates.sh").read_text())

    vendor = tmp_path / "vendor" / "demo-template"
    instr = tmp_path / "instructions" / "_demo-template"
    vendor.mkdir(parents=True)
    instr.mkdir(parents=True)

    gitmodules = tmp_path / ".gitmodules"
    gitmodules.write_text("""[submodule \"vendor/demo-template\"]\n  path = vendor/demo-template\n  url = https://example.com/demo-template\n""")

    codex = tmp_path / "codex.json"
    codex.write_text(json.dumps({"templates": ["demo-template"], "sources": []}))

    templates = tmp_path / "templates.txt"
    templates.write_text("\n")

    subprocess.run(["bash", str(tmp_scripts / "sync_templates.sh")], cwd=tmp_path, check=True)

    assert not vendor.exists()
    assert not instr.exists()
    data = json.loads(codex.read_text())
    assert "demo-template" not in data.get("templates", [])

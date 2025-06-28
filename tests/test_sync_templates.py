import json
import os
import subprocess
from pathlib import Path


def test_update_templates_removes_unused(tmp_path):
    repo_root = Path(__file__).resolve().parents[1]
    scripts_dir = repo_root / "scripts"
    tmp_scripts = tmp_path / "scripts"
    tmp_scripts.mkdir()
    (tmp_scripts / "update_templates.sh").write_text((scripts_dir / "update_templates.sh").read_text())
    (tmp_scripts / "remove_template.sh").write_text((scripts_dir / "remove_template.sh").read_text())

    vendor = tmp_path / "vendor" / "demo-template"
    instr = tmp_path / "instructions" / "_demo-template"
    vendor.mkdir(parents=True)
    instr.mkdir(parents=True)

    gitmodules = tmp_path / ".gitmodules"
    gitmodules.write_text("""[submodule \"vendor/demo-template\"]\n  path = vendor/demo-template\n  url = https://example.com/demo-template\n""")

    codex = tmp_path / "codex.json"
    codex.write_text(json.dumps({"templates": ["demo-template"], "sources": []}))

    # initial templates list containing the template
    templates = tmp_path / "templates.txt"
    templates.write_text("demo-template\n")

    # run update_templates with an empty templates file
    empty_list = tmp_path / "empty.txt"
    empty_list.write_text("\n")
    subprocess.run(
        ["bash", str(tmp_scripts / "update_templates.sh")],
        cwd=tmp_path,
        check=True,
        env={**os.environ, "TEMPLATE_FILE": str(empty_list)},
    )

    assert not vendor.exists()
    assert not instr.exists()
    data = json.loads(codex.read_text())
    assert "demo-template" not in data.get("templates", [])

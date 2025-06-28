import subprocess
from pathlib import Path
import json


def test_update_templates_empty(tmp_path):
    scripts = Path(__file__).resolve().parents[1] / "scripts"
    tmp_scripts = tmp_path / "scripts"
    tmp_scripts.mkdir()
    (tmp_scripts / "update_templates.sh").write_text((scripts / "update_templates.sh").read_text())

    codex = tmp_path / "codex.json"
    codex.write_text(json.dumps({"templates": [], "sources": []}))
    templates = tmp_path / "templates.txt"
    templates.write_text("\n")

    subprocess.run(["bash", str(tmp_scripts / "update_templates.sh")], cwd=tmp_path, check=True)

    data = json.loads(codex.read_text())
    assert data["templates"] == []


def test_update_templates_normalizes_templates_field(tmp_path):
    scripts = Path(__file__).resolve().parents[1] / "scripts"
    tmp_scripts = tmp_path / "scripts"
    tmp_scripts.mkdir()
    (tmp_scripts / "update_templates.sh").write_text((scripts / "update_templates.sh").read_text())
    (tmp_scripts / "remove_template.sh").write_text((scripts / "remove_template.sh").read_text())

    codex = tmp_path / "codex.json"
    codex.write_text('{"templates": {"foo": 1}, "sources": []}')
    templates = tmp_path / "templates.txt"
    templates.write_text("\n")

    subprocess.run(["bash", str(tmp_scripts / "update_templates.sh")], cwd=tmp_path, check=True)

    data = json.loads(codex.read_text())
    assert isinstance(data["templates"], list) and data["templates"] == []


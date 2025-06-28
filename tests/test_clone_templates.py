import subprocess
from pathlib import Path
import json


def test_clone_templates_empty(tmp_path):
    scripts = Path(__file__).resolve().parents[1] / "scripts"
    tmp_scripts = tmp_path / "scripts"
    tmp_scripts.mkdir()
    (tmp_scripts / "clone_templates.sh").write_text((scripts / "clone_templates.sh").read_text())

    codex = tmp_path / "codex.json"
    codex.write_text(json.dumps({"templates": [], "sources": []}))
    templates = tmp_path / "templates.txt"
    templates.write_text("\n")

    subprocess.run(["bash", str(tmp_scripts / "clone_templates.sh")], cwd=tmp_path, check=True)

    data = json.loads(codex.read_text())
    assert data["templates"] == []

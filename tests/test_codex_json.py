import json
from pathlib import Path

def test_codex_json_modify(tmp_path):
    repo_root = Path(__file__).resolve().parents[1]
    codex_file = tmp_path / "codex.json"
    codex_data = json.loads((repo_root / "codex.json").read_text())
    codex_data.setdefault("templates", [])
    codex_file.write_text(json.dumps(codex_data))

    data = json.loads(codex_file.read_text())
    assert isinstance(data.get("templates"), list)

    data["templates"].append("demo-template")
    codex_file.write_text(json.dumps(data))

    data = json.loads(codex_file.read_text())
    assert "demo-template" in data["templates"]

    data["templates"].remove("demo-template")
    codex_file.write_text(json.dumps(data))

    data = json.loads(codex_file.read_text())
    assert "demo-template" not in data["templates"]

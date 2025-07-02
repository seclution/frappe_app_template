from pathlib import Path
import json
from scripts import create_index


def test_build_index(tmp_path: Path):
    (tmp_path / "a.py").write_text("")
    (tmp_path / "b.js").write_text("")
    (tmp_path / "c.txt").write_text("")

    index = create_index.build_index(tmp_path, ["py", "js"])
    assert set(index.keys()) == {"py", "js"}
    assert index["py"] == ["a.py"]
    assert index["js"] == ["b.js"]


def test_cli(tmp_path: Path, monkeypatch):
    out = tmp_path / "out.json"
    args = ["--root", str(tmp_path), "--output", str(out)]
    (tmp_path / "file.py").write_text("")
    create_index.main(args)
    data = json.loads(out.read_text())
    assert data
    assert "py" in data

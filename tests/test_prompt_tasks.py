from pathlib import Path
from scripts import generate_index


def test_parse_prompts(tmp_path: Path):
    prompts = tmp_path / "projects.md"
    prompts.write_text("\n".join([
        "[Doctype] Create",
        "[API,Website] Build"
    ]))

    tasks = generate_index.parse_prompts(tmp_path)
    assert tasks["Doctype"] == ["- Create"]
    assert tasks["API"] == ["- Build"]
    assert tasks["Website"] == ["- Build"]


def test_index_includes_tasks(tmp_path: Path):
    (tmp_path / "instructions" / "vendors").mkdir(parents=True)
    (tmp_path / "vendor" / "foo").mkdir(parents=True)
    (tmp_path / "projects.md").write_text("[API] Example task")
    (tmp_path / "PROJECT.md").write_text("## Tags\nfoo")

    vendor_links = generate_index.generate_vendor_summaries(tmp_path)
    tags = generate_index.extract_tags(tmp_path)
    tag_map = generate_index.map_tags_to_vendors(tags, tmp_path)
    tasks = generate_index.parse_prompts(tmp_path)
    generate_index.write_index(vendor_links, tags, tag_map, tmp_path, tasks)

    text = (tmp_path / "instructions" / "_INDEX.md").read_text()
    assert "## Tasks" in text
    assert "### API" in text
    assert "Example task" in text

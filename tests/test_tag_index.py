from pathlib import Path
from scripts import generate_index


def test_extract_tags(tmp_path: Path):
    project = tmp_path / "PROJECT.md"
    project.write_text("## Tags\nfoo, bar")
    tags = generate_index.extract_tags(tmp_path)
    assert tags == ["foo", "bar"]


def test_index_generation(tmp_path: Path):
    # create minimal repo structure
    (tmp_path / "instructions" / "vendors").mkdir(parents=True)
    vendors = tmp_path / "vendor"
    (vendors / "foo-tool").mkdir(parents=True)
    (vendors / "barapp").mkdir(parents=True)
    (tmp_path / "PROJECT.md").write_text("## Tags\nfoo")

    vendor_links = generate_index.generate_vendor_summaries(tmp_path)
    tags = generate_index.extract_tags(tmp_path)
    tag_map = generate_index.map_tags_to_vendors(tags, tmp_path)
    generate_index.write_index(vendor_links, tags, tag_map, tmp_path)

    index_file = tmp_path / "instructions" / "_INDEX.md"
    text = index_file.read_text()
    assert "## Tags" in text
    assert "### foo" in text
    assert "foo-tool" in text

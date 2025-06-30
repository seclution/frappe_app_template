import argparse
import json
from pathlib import Path


def parse_args(args=None):
    parser = argparse.ArgumentParser(
        description="Print codex context and prompt for a scenario"
    )
    parser.add_argument(
        "--scenario", required=True, help="Name of the scenario without extension"
    )
    return parser.parse_args(args)


def load_sources():
    with open("codex.json") as f:
        data = json.load(f)
    return data.get("sources", [])


def parse_scenario_file(name):
    path = Path("instructions") / "_scenarios" / f"{name}.md"
    if not path.is_file():
        raise FileNotFoundError(f"Scenario file not found: {path}")
    content = path.read_text().splitlines()

    prompt = None
    references = []
    in_refs = False
    for i, line in enumerate(content):
        stripped = line.strip()
        lower = stripped.lower()
        if lower.startswith("prompt"):
            # take next non-empty line as prompt
            j = i + 1
            while j < len(content) and not content[j].strip():
                j += 1
            if j < len(content):
                prompt = content[j].strip()
        if stripped.startswith("References:"):
            in_refs = True
            continue
        if in_refs:
            if not stripped or stripped.startswith("#"):
                break
            if stripped.startswith("-") or stripped.startswith("*"):
                stripped = stripped[1:].strip()
            references.append(stripped)
    return path, prompt, references


def main(argv=None):
    args = parse_args(argv)
    scenario_file, prompt, refs = parse_scenario_file(args.scenario)
    sources = load_sources()

    print(f"Scenario file: {scenario_file}")
    print(f"Suggested prompt: {prompt or '(none)'}")
    print("\nIndexed entries:")
    all_refs = [str(scenario_file)] + refs
    for ref in all_refs:
        try:
            idx = sources.index(ref)
        except ValueError:
            idx = -1
        print(f"{idx}: {ref}")


if __name__ == "__main__":
    main()

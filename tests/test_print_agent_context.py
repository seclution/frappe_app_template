from scripts.print_agent_context import parse_args


def test_parse_args():
    args = parse_args(['--scenario', 'demo'])
    assert args.scenario == 'demo'

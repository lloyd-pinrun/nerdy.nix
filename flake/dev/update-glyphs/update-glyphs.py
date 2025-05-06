import json
import urllib.request as ureq
import rtoml

from argparse import ArgumentParser, RawTextHelpFormatter
from dataclasses import dataclass
from pathlib import Path


@dataclass
class ProgramArguments:
    filename: str | None = None


def fetch_json(url):
    with ureq.urlopen(url) as request:
        return json.loads(request.read())


def read_json(target):
    with target.open("r") as file:
        return json.loads(file.read())


def nest_key(d, key, value):
    acc = d
    parts = key.replace("-", "_").split("_")

    for i, part in enumerate(parts):
        last = i == len(parts) - 1
        name = part.capitalize() if last else part

        if not last:
            if name not in acc or not isinstance(acc[name], dict):
                acc[name] = {}
            acc = acc[name]
        else:
            acc[name] = value


def sort_nested(d):
    sorted_dict = {}
    for key in sorted(d.keys()):
        value = d[key]
        if isinstance(value, dict):
            sorted_dict[key] = sort_nested(value)
        else:
            sorted_dict[key] = value
    return sorted_dict


def format_glyphs(raw: dict) -> dict:
    raw.pop("METADATA", None)
    formatted = {}

    for name, info in raw.items():
        if "char" in info:
            nest_key(formatted, name, info["char"])

    return sort_nested(formatted)


def load_raw(input: str, is_file: bool = False) -> dict:
    if is_file:
        path = Path(input)
        return read_json(path)
    else:
        return fetch_json(url)


def main(args) -> None:
    url = (
        "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json"
    )

    filename = args.filename
    is_file = False if filename is None else True
    input = filename if is_file else url

    glyphs = load_raw(input, is_file=is_file)
    glyphs = format_glyphs(glyphs)

    print(rtoml.dumps(glyphs, pretty=True))


if __name__ == "__main__":
    parser: ArgumentParser = ArgumentParser(
        description="""
        Convert nerd-fonts 'glyphnames.json' into nested & sorted TOML.
        The outputted toml is written to a file, which is used to build `config.lib.nerdy`.
        """,
        formatter_class=RawTextHelpFormatter,
    )

    parser.add_argument(
        "filename",
        help="""
        The path to a valid `glyphnames.json`. If not provided, `glyphnames` are pulled from:
        'https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json'
        """,
        nargs="?",
    )

    program_args: ProgramArguments = parser.parse_args(namespace=ProgramArguments())

    url = (
        "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json"
    )

    main(program_args)

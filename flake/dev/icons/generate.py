# keep-sorted start
import json
import os
import rtoml
import subprocess
import urllib.request as ureq
# keep-sorted end

# keep-sorted start
from argparse import ArgumentParser, RawTextHelpFormatter
from collections import defaultdict
from pathlib import Path
# keep-sorted end

url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json"


class ProgramArguments:
    input_file: Path | None
    output_dir: Path | None


def fetch_json(url):
    with ureq.urlopen(url) as request:
        return json.loads(request.read())


def read_json(target):
    with target.open("r") as file:
        return json.loads(file.read())


def sort_nested(d: dict) -> dict:
    result = {}

    for key in sorted(d.keys()):
        value = d[key]
        result[key] = sort_nested(value) if isinstance(value, dict) else value

    return result


def format_glyphs(raw: dict) -> dict:
    def nest_key(acc: dict, key: str, value: str):
        parts = key.replace("-", "_").split("_")

        for i, part in enumerate(parts):
            last = i == len(parts) - 1
            key = part.capitalize() if last else part

            if not last:
                if key not in acc or not isinstance(acc[key], dict):
                    acc[key] = {}
                acc = acc[key]
            else:
                acc[key] = value

    raw.pop("METADATA", None)
    result = {}

    for name, info in raw.items():
        if "char" in info:
            nest_key(result, name, info["char"])

    return sort_nested(result)


def categorize_glyphs(glyphs: dict) -> dict:
    result = defaultdict(dict)

    for key, value in glyphs.items():
        result[key] = value

    return result


def load_raw(input: Path | None) -> dict:
    if input is not None and os.path.isfile(input):
        return read_json(input)
    else:
        return fetch_json(url)


def main(args) -> None:
    input_file = args.input_file
    output_dir = args.output_dir

    glyphs = load_raw(input_file)
    formatted = format_glyphs(glyphs)
    categorized = categorize_glyphs(formatted)

    for category, content in categorized.items():
        toml = rtoml.dumps(content, pretty=True)

        if output_dir is not None:
            os.makedirs(output_dir, exist_ok=True)
            output_file = Path(os.path.join(output_dir, f"{category}.toml"))

            with open(output_file, "w") as file:
                file.write(toml)

            print(f"Created {output_file}")
        else:
            print(toml)


if __name__ == "__main__":
    parser: ArgumentParser = ArgumentParser(
        description="""
        Convert nerd-fonts 'glyphnames.json' into nested & sorted TOML.
        The outputted toml is written to a file, which is used to build `config.lib.nerdy`.
        """,
        formatter_class=RawTextHelpFormatter,
    )

    parser.add_argument(
        "input_file",
        # keep-sorted start block=yes
        help=f"""
        The path to a valid `glyphnames.json`. If not provided, `glyphnames` are pulled from:
        '{url}'
        """,
        nargs="?",
        type=Path,
        # keep-sorted end
    )

    def output_dir_default() -> Path | None:
        command = ["git", "rev-parse", "--show-toplevel"]
        process = subprocess.run(command, capture_output=True, text=True, check=True)
        output_dir = (
            Path(os.path.join(process.stdout, "generated")) if process.stdout else None
        )

        return output_dir

    parser.add_argument(
        "--output",
        "-o",
        # keep-sorted start block=yes
        default=output_dir_default(),
        dest="output_dir",
        help="""
        Specify a directory to save the formatted TOML files. Each category (e.g. `fa`, `oct`, etc)
        will have its own related TOML file. If not provided, the output will be printed instead.

        Defaults to: ${config.git.root}/generated (see: https://devenv.sh/tasks/#processes-as-tasks)
        """,
        type=Path,
        # keep-sorted end
    )

    program_args: ProgramArguments = parser.parse_args(namespace=ProgramArguments())

    main(program_args)

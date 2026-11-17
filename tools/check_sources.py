"""Parse maintained Python source without importing the application."""

import ast
import os
import subprocess
import tokenize
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def main() -> None:
    names = subprocess.check_output(
        ["git", "ls-files", "-z", "--", "*.py"], cwd=ROOT
    ).split(b"\0")
    count = 0
    for name in filter(None, names):
        path = ROOT / os.fsdecode(name)
        with tokenize.open(path) as stream:
            ast.parse(stream.read(), filename=str(path))
        count += 1
    print(f"Parsed {count} tracked Python files without application imports.")


if __name__ == "__main__":
    main()

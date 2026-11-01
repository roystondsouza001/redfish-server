#!/usr/bin/env python3
"""Record deliberate dependency changes, or check the installation against Git."""
import argparse
import importlib.metadata
import json
from pathlib import Path
import platform
import subprocess
import sys

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--check", action="store_true", help="Check records without changing them")
args = parser.parse_args()
root = Path(__file__).resolve().parent.parent
tools = root / ".tools"
packages = subprocess.check_output([sys.executable, "-m", "pip", "freeze", "--all"], text=True)
inventory = {
    "platform": f"{platform.system()} {platform.machine()}",
    "python": platform.python_version(),
    "uv": subprocess.check_output([str(tools / "bootstrap/uv"), "--version"], text=True).strip(),
    "esp_idf_commit": subprocess.check_output(
        ["git", "-C", str(tools / "esp-idf"), "rev-parse", "HEAD"], text=True
    ).strip(),
    "tools": {
        path.name: sorted(child.name for child in path.iterdir() if child.is_dir())
        for path in sorted((tools / "espressif/tools").iterdir()) if path.is_dir()
    },
    "python_packages": dict(sorted(
        (dist.metadata["Name"], dist.version) for dist in importlib.metadata.distributions()
    )),
}
records = {
    root / "environment/requirements.lock": packages,
    root / "environment/installed.json": json.dumps(inventory, indent=2) + "\n",
}
for path, content in records.items():
    if args.check:
        if not path.exists() or path.read_text() != content:
            sys.exit(f"Environment differs from {path.name}. Review dependencies and rerun record-environment.py.")
    else:
        path.write_text(content)
print("Environment matches the tracked records." if args.check else "Updated environment records; review and commit the changes.")

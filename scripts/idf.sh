#!/usr/bin/env bash
set -e

source "$(dirname -- "${BASH_SOURCE[0]}")/environment.sh"

if [[ ! -f "$PROJECT_DIR/.tools/esp-idf/export.sh" ]]; then
    echo "ESP-IDF is missing. See README.md for setup instructions." >&2
    exit 1
fi

source "$PROJECT_DIR/.tools/esp-idf/export.sh" >&2
cd "$PROJECT_DIR"
exec idf.py "$@"

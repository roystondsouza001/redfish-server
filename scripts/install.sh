#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/environment.sh"

if [[ "$(uname -s)/$(uname -m)" != Linux/x86_64 ]]; then
    echo "This installer supports Linux x86-64 (including WSL2)." >&2
    exit 1
fi
for command_name in bash curl git tar xz sha256sum; do
    command -v "$command_name" >/dev/null || {
        echo "Missing prerequisite: $command_name. Install it with your OS package manager." >&2
        exit 1
    }
done

mkdir -p "$PROJECT_DIR/.tools/bootstrap"
UV_BIN="$PROJECT_DIR/.tools/bootstrap/uv"
if [[ ! -x "$UV_BIN" ]] || [[ "$("$UV_BIN" --version)" != "uv $UV_VERSION "* ]]; then
    archive="$PROJECT_DIR/.tools/bootstrap/uv.tar.gz"
    curl --fail --location --retry 3 \
        "https://github.com/astral-sh/uv/releases/download/$UV_VERSION/uv-x86_64-unknown-linux-gnu.tar.gz" \
        --output "$archive"
    printf '%s  %s\n' "$UV_ARCHIVE_SHA256" "$archive" | sha256sum --check
    tar -xzf "$archive" -C "$PROJECT_DIR/.tools/bootstrap" --strip-components=1
fi
"$UV_BIN" python install "$PROJECT_PYTHON_VERSION" --no-bin
python3 --version

SDK_DIR="$PROJECT_DIR/.tools/esp-idf"
if [[ ! -d "$SDK_DIR" ]]; then
    git clone --branch "$ESP_IDF_VERSION" --depth 1 \
        https://github.com/espressif/esp-idf.git "$SDK_DIR"
fi
if [[ "$(git -C "$SDK_DIR" rev-parse HEAD)" != "$ESP_IDF_COMMIT" ]]; then
    echo "Existing .tools/esp-idf differs from the pinned SDK. Move it aside and rerun." >&2
    exit 1
fi
git -C "$SDK_DIR" submodule update --init --recursive --depth 1
python3 "$SDK_DIR/tools/idf_tools.py" install --targets=esp32p4
python3 "$SDK_DIR/tools/idf_tools.py" install cmake ninja

if [[ ! -x "$PROJECT_VENV/bin/python" ]]; then
    python3 -m venv "$PROJECT_VENV"
fi
"$PROJECT_VENV/bin/python" -m pip install --requirement "$PROJECT_DIR/environment/requirements.lock"

# Match ESP-IDF's venv metadata and validate against the recorded constraints.
# Avoid install-python-env here: it upgrades packages to whatever is newest.
printf '%s' "${ESP_IDF_VERSION#v}" | cut -d. -f1,2 > "$PROJECT_VENV/idf_version.txt"
cp "$PROJECT_DIR/environment/espidf.constraints.v5.5.txt" "$IDF_TOOLS_PATH/espidf.constraints.v5.5.txt"
python3 "$SDK_DIR/tools/idf_tools.py" check-python-dependencies
bash "$PROJECT_DIR/scripts/idf.sh" --version
"$PROJECT_VENV/bin/python" "$PROJECT_DIR/scripts/record-environment.py" --check
echo "Setup complete. Build with: ./scripts/idf.sh build"

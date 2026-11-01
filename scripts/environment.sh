#!/usr/bin/env bash
# Shared environment; source this file rather than executing it.
PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_DIR/environment/versions.env"
export IDF_TOOLS_PATH="$PROJECT_DIR/.tools/espressif"
export PATH="$PROJECT_DIR/.tools/python/cpython-${PROJECT_PYTHON_VERSION}-linux-x86_64-gnu/bin:$PATH"
export PIP_CACHE_DIR="$PROJECT_DIR/.tools/pip-cache"
export XDG_CACHE_HOME="$PROJECT_DIR/.tools/cache"
export UV_PYTHON_INSTALL_DIR="$PROJECT_DIR/.tools/python"
export UV_CACHE_DIR="$PROJECT_DIR/.tools/uv-cache"
export UV_PYTHON_BIN_DIR="$PROJECT_DIR/.tools/bin"
# ESP-IDF virtual environments use the SDK's major.minor, without patch version.
PROJECT_VENV="$IDF_TOOLS_PATH/python_env/idf$(printf '%s' "${ESP_IDF_VERSION#v}" | cut -d. -f1,2)_py$(printf '%s' "$PROJECT_PYTHON_VERSION" | cut -d. -f1,2)_env"

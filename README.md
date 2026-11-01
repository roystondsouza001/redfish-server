# Redfish Server

ESP-IDF firmware project for the Olimex ESP32-P4-DevKit. The starter application
prints chip information and a heartbeat every five seconds over USB Serial/JTAG.
It does not yet implement a Redfish service.

## Local development

After cloning, install the development environment with:

```bash
./scripts/install.sh
```

The installer supports **Linux x86-64**, including WSL2, and needs Bash, Git,
curl, tar, xz, SHA-256 utilities, and internet access. It downloads Python itself;
neither an existing Python installation nor sudo is needed. Downloads can take
several minutes and currently occupy about 4 GB including caches.

It installs ESP-IDF **v5.5.6**, Python **3.12.16**, the ESP32-P4 toolchain, CMake,
Ninja, debugging tools, and the recorded Python packages. Everything lives in
ignored `.tools/`; no global shell configuration is needed. Rerunning the script
reuses matching downloads and verifies the installed versions against Git.

```bash
bash scripts/idf.sh build
bash scripts/idf.sh menuconfig
```

Connect the board's USB-C programming port with a data cable. On Linux it usually
appears as `/dev/ttyACM0`; use the actual device name:

```bash
bash scripts/idf.sh -p /dev/ttyACM0 flash monitor
```

Exit the monitor with **Ctrl+]**. Flashing replaces the existing firmware.
If the serial port is inaccessible, check its permissions and your membership in
the device's owning group (usually `dialout`).

## Board configuration

Defaults select ESP32-P4, 16 MiB flash, and USB Serial/JTAG console. PSRAM and
external peripherals are left disabled for the initial bring-up.

The initial configuration targets chip revisions **below v3.0**. ESP-IDF v5.5.6
requires separate builds for pre-v3 and v3+ chips. Before flashing, identify the
connected chip using the installed Python environment:

```bash
.tools/espressif/python_env/idf5.5_py3.12_env/bin/python -m esptool \
  --chip esp32p4 --port /dev/ttyACM0 chip_id
```

For v3+ chips, disable
`CONFIG_ESP32P4_SELECTS_REV_LESS_V3` and select the appropriate minimum revision
under **Component config → Hardware Settings → Chip revision** in `menuconfig`.
Do not bypass esptool's chip-revision checks.

## Dependency records and future changes

The files in `environment/` are tracked; the installed packages are not:

- `versions.env`: pinned SDK commit, Python version, uv version and archive checksum.
- `requirements.lock`: exact Python package versions, including transitive dependencies.
- `installed.json`: recorded toolchain and package inventory.
- `espidf.constraints.v5.5.txt`: snapshot of Espressif's compatible package ranges.
- `HISTORY.md`: previous installations and reasons for future changes.

When introducing a tool or dependency, update the installer or its inputs so a
new clone installs it too. After deliberately changing Python packages or tools,
record the updated environment:

```bash
.tools/espressif/python_env/idf5.5_py3.12_env/bin/python scripts/record-environment.py
./scripts/install.sh
./scripts/idf.sh build
```

Review the changed records, add an entry to `environment/HISTORY.md`, and commit
them together with the installation changes. `AGENTS.md` requires the same
workflow for future agent work. New firmware components should use ESP-IDF
component manifests and committed lock files.

The record command captures the current installation; it does not automatically
teach the installer how to install a new tool. Update `scripts/install.sh` for
any new tool before committing the records. To check for drift without changing
tracked files, run the record command with `--check`.

Documentation: [Olimex board](https://www.olimex.com/Products/IoT/ESP32-P4/ESP32-P4-DevKit/open-source-hardware),
[ESP-IDF](https://docs.espressif.com/projects/esp-idf/en/v5.5.6/esp32p4/).

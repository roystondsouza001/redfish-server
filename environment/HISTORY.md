# Dependency history

## 2026-11-01 — Initial ESP32-P4 environment

Installed locally without sudo:

- ESP-IDF v5.5.6, commit `880a203ae603d08a94d06aa01e0d6761958e5e9e`.
- uv 0.13.6 and managed Python 3.12.16.
- RISC-V GCC 14.2.0 (`esp-14.2.0_20260121`).
- CMake 3.30.2 and Ninja 1.12.1.
- RISC-V GDB 17.1 (`17.1_20260402`).
- OpenOCD `v0.12.0-esp32-20260831` and ROM ELF symbols `20260528`.
- ESP-IDF Python tools and transitive dependencies, including esptool 4.12.0,
  ESP-IDF Monitor 1.10.0, and Component Manager 2.5.2. Full versions are recorded
  in `requirements.lock` and `installed.json`.

Git, curl, tar, xz, and system Python already existed. The attempted sudo package
installation did not run because sudo required authentication; no system packages
were installed. The installer now downloads all development tools into `.tools/`.

Future dependency changes must add an entry here describing what changed, why,
and how installation and compilation were verified. Update the installer and
version records in the same commit.

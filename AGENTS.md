# Development environment

- Keep downloaded SDKs, Python environments, toolchains, caches, and build outputs
  out of Git. `.tools/` and `build/` are ignored.
- `scripts/install.sh` is the source of truth for installing development tools.
  Any future dependency installation or upgrade must update that script and/or
  its inputs in `environment/`, so a new clone can reproduce it.
- After an intentional Python dependency change, run the ESP-IDF environment's
  Python on `scripts/record-environment.py`, review `environment/requirements.lock`
  and `environment/installed.json`, and add an entry to `environment/HISTORY.md`.
- For firmware component dependencies, use ESP-IDF component manifests and commit
  their lock files. Keep downloaded `managed_components/` ignored.
- Verify dependency changes with `./scripts/install.sh`, then
  `./scripts/idf.sh build`. Do not install project tools globally or require sudo
  when a project-local installation works.

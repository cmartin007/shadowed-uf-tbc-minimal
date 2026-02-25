# AGENTS.md

## Cursor Cloud specific instructions

This is a **WoW addon** (Lua) with a companion **Python API test suite**. There is no web server, database, or Docker dependency.

### Services

| Component | Language | Purpose |
|---|---|---|
| Lua addon (ShadowedUnitFrames) | Lua 5.1 | WoW Classic TBC unit frames addon — runs inside the WoW game client only |
| Python API tests | Python 3.12 | Validates Battle.net WoW Classic Game Data REST API contracts |

### Standard commands

- **Lint**: `bash build/lint.sh` (runs `luacheck` on all Lua source files)
- **Build**: `bash build/build.sh` (assembles release into `build/release/`)
- **Tests**: `source .venv/bin/activate && python3 -m pytest test/ -v` (or `./run_api_tests.sh` with venv active)
- See `test/README.md` for full Python test setup details.

### Non-obvious caveats

- `build/build.sh` exits non-zero when `luacheck` finds warnings during its lint phase, because `set -e` is active and `luacheck` returns exit code 1 for warnings. The file copy/build itself succeeds before the lint step runs. Use `bash build/build.sh || true` if you just need the build artifacts.
- API tests that call the live Blizzard API require `BLIZZARD_CLIENT_ID` and `BLIZZARD_CLIENT_SECRET` in `test/.env`. Without credentials, those tests are skipped (only `test_sanity` runs). This is expected.
- The `.luacheckrc` at the repo root defines WoW-specific globals; `luacheck` must be run from the repo root (or with `--config .luacheckrc`) for correct results.
- The Python venv lives at `.venv/` in the repo root. Always `source .venv/bin/activate` before running Python commands.

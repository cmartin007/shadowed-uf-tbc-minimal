#!/usr/bin/env bash

set -euo pipefail

# Always run from repo root
cd "$(dirname "$0")"

# Check that pytest is available without trying to install system-wide
if ! python3 -m pytest --version >/dev/null 2>&1; then
  cat <<'EOF'
pytest is not installed in this environment.

Recommended setup (once per checkout):

  python3 -m venv .venv
  source .venv/bin/activate
  python3 -m pip install -r test/requirements.txt

Then run:

  source .venv/bin/activate
  ./run_api_tests.sh

EOF
  exit 1
fi

echo "Running Blizzard API tests..."

PYTEST_FLAGS="-v"
# When BLIZZARD_API_DEBUG=1, show print output during tests
if [[ "${BLIZZARD_API_DEBUG:-0}" == "1" ]]; then
  PYTEST_FLAGS="-v -s"
fi

python3 -m pytest test/ ${PYTEST_FLAGS} "$@"


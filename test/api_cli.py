#!/usr/bin/env python3
"""
One-line Blizzard API tester. Uses .env credentials (see .env.example).

Usage:
  python test/api_cli.py /data/wow/playable-class/index
  python test/api_cli.py /data/wow/connected-realm/index --namespace dynamic
  python test/api_cli.py /data/wow/playable-race/index -n static

From repo root or from test/ (with venv active).
"""
import argparse
import json
import sys
from pathlib import Path

# Allow running from repo root or test/
_root = Path(__file__).resolve().parent
if str(_root) not in sys.path:
    sys.path.insert(0, str(_root))

import requests

from config import (
    API_BASE,
    BLIZZARD_CLIENT_ID,
    BLIZZARD_CLIENT_SECRET,
    BLIZZARD_LOCALE,
    NAMESPACE_DYNAMIC,
    NAMESPACE_STATIC,
    TOKEN_URL,
)


def get_token():
    r = requests.post(
        TOKEN_URL,
        data={"grant_type": "client_credentials"},
        auth=(BLIZZARD_CLIENT_ID, BLIZZARD_CLIENT_SECRET),
        timeout=10,
    )
    r.raise_for_status()
    return r.json()["access_token"]


def main():
    parser = argparse.ArgumentParser(
        description="One-line GET request to Blizzard WoW Classic Game Data API."
    )
    parser.add_argument(
        "path",
        help="API path, e.g. /data/wow/playable-class/index",
    )
    parser.add_argument(
        "-n",
        "--namespace",
        choices=["static", "dynamic"],
        default="static",
        help="Namespace: static (default) or dynamic (e.g. for connected-realm)",
    )
    parser.add_argument(
        "-l",
        "--locale",
        default=BLIZZARD_LOCALE,
        help=f"Locale (default: {BLIZZARD_LOCALE})",
    )
    args = parser.parse_args()

    if not BLIZZARD_CLIENT_ID or not BLIZZARD_CLIENT_SECRET:
        print("Set BLIZZARD_CLIENT_ID and BLIZZARD_CLIENT_SECRET (e.g. in test/.env)", file=sys.stderr)
        sys.exit(1)

    path = args.path if args.path.startswith("/") else "/" + args.path
    namespace = NAMESPACE_DYNAMIC if args.namespace == "dynamic" else NAMESPACE_STATIC

    token = get_token()
    url = f"{API_BASE}{path}"
    r = requests.get(
        url,
        params={"namespace": namespace, "locale": args.locale},
        headers={"Authorization": f"Bearer {token}"},
        timeout=15,
    )

    print("URL:", r.url)
    print("Status:", r.status_code)
    if r.ok:
        try:
            print(json.dumps(r.json(), indent=2))
        except ValueError:
            print(r.text)
    else:
        print(r.text)
    sys.exit(0 if r.ok else 1)


if __name__ == "__main__":
    main()

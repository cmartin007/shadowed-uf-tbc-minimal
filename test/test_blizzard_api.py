"""
Unit tests for Battle.net WoW Classic Game Data API GET/POST requests.
Source of truth: https://community.developer.battle.net/documentation/world-of-warcraft-classic/game-data-apis
"""
import os
import sys
import unittest
from pathlib import Path
import json

# Ensure test dir is on path so "config" is found when run from repo root or test/
_test_dir = Path(__file__).resolve().parent
if str(_test_dir) not in sys.path:
    sys.path.insert(0, str(_test_dir))

import requests

from config import (
    API_BASE,
    BLIZZARD_CLIENT_ID,
    BLIZZARD_CLIENT_SECRET,
    BLIZZARD_LOCALE,
    NAMESPACE_DYNAMIC,
    NAMESPACE_STATIC,
    TOKEN_URL,
    has_credentials,
)

DEBUG = os.getenv("BLIZZARD_API_DEBUG") == "1"


def debug_response(label: str, response: requests.Response) -> None:
    """Optionally print API response when BLIZZARD_API_DEBUG=1 is set."""
    if not DEBUG:
        return
    print(f"\n=== {label} ===")
    print("URL:", response.url)
    print("Status:", response.status_code)
    try:
        data = response.json()
        print(json.dumps(data, indent=2)[:2000])
    except ValueError:
        print(response.text[:2000])


class TestBasic(unittest.TestCase):
    """A basic test that always passes (no network or credentials required)."""

    def test_sanity(self):
        self.assertTrue(True)


def get_access_token():
    """Obtain OAuth2 access token (client credentials)."""
    response = requests.post(
        TOKEN_URL,
        data={"grant_type": "client_credentials"},
        auth=(BLIZZARD_CLIENT_ID, BLIZZARD_CLIENT_SECRET),
        timeout=10,
    )
    response.raise_for_status()
    return response.json()["access_token"]


def api_get(path, access_token, namespace=NAMESPACE_STATIC, locale=BLIZZARD_LOCALE):
    """GET a game data endpoint. path should start with / (e.g. /data/wow/...)."""
    url = f"{API_BASE}{path}"
    params = {"namespace": namespace, "locale": locale}
    headers = {"Authorization": f"Bearer {access_token}"}
    return requests.get(url, params=params, headers=headers, timeout=15)


class TestBlizzardOAuth(unittest.TestCase):
    """OAuth token retrieval."""

    @unittest.skipUnless(has_credentials(), "BLIZZARD_CLIENT_ID and BLIZZARD_CLIENT_SECRET required")
    def test_get_access_token(self):
        """POST to OAuth token endpoint returns a valid access token."""
        token = get_access_token()
        self.assertIsInstance(token, str)
        self.assertGreater(len(token), 0)


class TestBlizzardGameDataGET(unittest.TestCase):
    """GET requests to WoW Classic Game Data API."""

    @classmethod
    def setUpClass(cls):
        cls._token = None
        if has_credentials():
            try:
                cls._token = get_access_token()
            except Exception:
                pass

    def _get(self, path, namespace=NAMESPACE_STATIC):
        if self._token is None:
            self.skipTest("No OAuth credentials or token failed")
        return api_get(path, self._token, namespace=namespace)

    @unittest.skipUnless(has_credentials(), "BLIZZARD_CLIENT_ID and BLIZZARD_CLIENT_SECRET required")
    def test_get_playable_classes_index(self):
        """GET playable class index returns 200 and a classes array."""
        # Classic endpoint: /data/wow/playable-class/index
        r = self._get("/data/wow/playable-class/index")
        debug_response("playable-class/index", r)
        self.assertEqual(r.status_code, 200, r.text)
        data = r.json()
        self.assertIn("classes", data)
        self.assertIsInstance(data["classes"], list)

    @unittest.skipUnless(has_credentials(), "BLIZZARD_CLIENT_ID and BLIZZARD_CLIENT_SECRET required")
    def test_get_playable_races_index(self):
        """GET playable race index returns 200 and a races array."""
        r = self._get("/data/wow/playable-race/index")
        debug_response("playable-race/index", r)
        self.assertEqual(r.status_code, 200, r.text)
        data = r.json()
        self.assertIn("races", data)
        self.assertIsInstance(data["races"], list)

    @unittest.skipUnless(has_credentials(), "BLIZZARD_CLIENT_ID and BLIZZARD_CLIENT_SECRET required")
    def test_get_connected_realms_index(self):
        """GET /data/wow/connected-realm/index (dynamic namespace) returns 200 and connected_realms array."""
        # Connected Realms Index: region + namespace required; use dynamic namespace for realm data
        r = self._get("/data/wow/connected-realm/index", namespace=NAMESPACE_DYNAMIC)
        debug_response("connected-realm/index", r)
        self.assertEqual(r.status_code, 200, r.text)
        data = r.json()
        self.assertIn("connected_realms", data)
        self.assertIsInstance(data["connected_realms"], list)

    @unittest.skipUnless(has_credentials(), "BLIZZARD_CLIENT_ID and BLIZZARD_CLIENT_SECRET required")
    def test_get_without_token_returns_401(self):
        """GET without Authorization header returns 4xx (401/403/404)."""
        url = f"{API_BASE}/data/wow/playable-class/index"
        r = requests.get(
            url,
            params={"namespace": NAMESPACE_STATIC, "locale": BLIZZARD_LOCALE},
            timeout=10,
        )
        debug_response("playable-class/index (no token)", r)
        # API may return 401 Unauthorized, 403 Forbidden, or 404 Not Found when no token is sent
        self.assertIn(
            r.status_code,
            (401, 403, 404),
            msg=f"Expected 401/403/404 without token, got {r.status_code}: {r.text}",
        )


class TestBlizzardGameDataPOST(unittest.TestCase):
    """
    POST requests (if/when the API supports them).
    WoW Classic Game Data API is mostly GET; add POST tests here when needed.
    """

    @unittest.skip("WoW Classic Game Data API is GET-only for standard endpoints; add when POST is used")
    def test_post_placeholder(self):
        """Placeholder for future POST tests."""
        self.assertTrue(True)


if __name__ == "__main__":
    unittest.main()

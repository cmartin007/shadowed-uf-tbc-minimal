"""
Config for Blizzard API tests. Loads from .env (see .env.example).
Source: https://community.developer.battle.net/documentation/world-of-warcraft-classic/game-data-apis
"""
import os

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

BLIZZARD_CLIENT_ID = os.getenv("BLIZZARD_CLIENT_ID", "")
BLIZZARD_CLIENT_SECRET = os.getenv("BLIZZARD_CLIENT_SECRET", "")
BLIZZARD_REGION = os.getenv("BLIZZARD_REGION", "us").lower()
BLIZZARD_LOCALE = os.getenv("BLIZZARD_LOCALE", "en_US")

# OAuth token endpoint
OAUTH_BASE = f"https://{BLIZZARD_REGION}.battle.net"
TOKEN_URL = f"{OAUTH_BASE}/oauth/token"

# Game Data API base (WoW Classic)
API_BASE = f"https://{BLIZZARD_REGION}.api.blizzard.com"

# WoW Classic namespaces (static = patch data, dynamic = frequently changing)
# See: https://develop.battle.net/documentation/world-of-warcraft-classic/guides/namespaces
NAMESPACE_STATIC = f"static-classic-{BLIZZARD_REGION}"
NAMESPACE_DYNAMIC = f"dynamic-classic-{BLIZZARD_REGION}"


def has_credentials():
    """True if client id and secret are set (non-empty)."""
    return bool(BLIZZARD_CLIENT_ID and BLIZZARD_CLIENT_SECRET)

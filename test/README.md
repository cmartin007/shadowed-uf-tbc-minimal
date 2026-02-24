# Blizzard / Battle.net API tests

Unit tests for **GET/POST requests** to the [Battle.net WoW Classic Game Data APIs](https://community.developer.battle.net/documentation/world-of-warcraft-classic/game-data-apis). These run outside the game and validate API contracts and auth.

## Requirements

- Python 3.8+
- See `requirements.txt` for dependencies.

## Setup

### Recommended: virtual environment

On many systems (e.g. Homebrew Python), `pip install` is not allowed system-wide. Use a venv once per checkout:

```bash
# From repo root
python3 -m venv .venv
source .venv/bin/activate   # On Windows: .venv\Scripts\activate
python3 -m pip install -r test/requirements.txt
```

Then run tests with the venv active (see **Running tests** below).

### 1. Create a Battle.net API client (optional, for live API tests)

- Go to [Battle.net Developer Portal – API Access](https://develop.battle.net/access/clients).
- Create a client and note **Client ID** and **Client Secret**.

### 2. Configure credentials (optional)

If you want to run the live-API tests:

```bash
cp test/.env.example test/.env
# Edit test/.env and set BLIZZARD_CLIENT_ID and BLIZZARD_CLIENT_SECRET
```

## Running tests

**Option A – script from repo root** (after venv setup above):

```bash
source .venv/bin/activate
./run_api_tests.sh
```

**Option B – pytest directly:**

```bash
source .venv/bin/activate
python3 -m pytest test/ -v
```

Or from the **test/** directory with venv active: `pytest -v`.

Without credentials, tests that call the live API are **skipped**. With a valid `.env`, they run real GET (and POST, if added) requests against the Blizzard API.

## One-line API requests

Use `api_cli.py` to hit a single endpoint and print the response (no test run):

```bash
source .venv/bin/activate

# Static namespace (default)
python test/api_cli.py /data/wow/playable-class/index
python test/api_cli.py /data/wow/playable-race/index

# Dynamic namespace (e.g. connected realms)
python test/api_cli.py /data/wow/connected-realm/index --namespace dynamic
python test/api_cli.py /data/wow/connected-realm/index -n dynamic
```

Options: `-n` / `--namespace` = `static` (default) or `dynamic`; `-l` / `--locale` to override locale. Requires `test/.env` with `BLIZZARD_CLIENT_ID` and `BLIZZARD_CLIENT_SECRET`.

## Structure

```
test/
├── README.md           # This file
├── requirements.txt    # Python deps
├── .env.example       # Template for .env (no secrets)
├── config.py           # Load env, base URLs, OAuth token
├── api_cli.py         # One-line API GET tool (see above)
├── test_blizzard_api.py # unittest/pytest cases for API calls
└── __init__.py
```

## Source of truth

API behavior and endpoints: [Battle.net – WoW Classic Game Data APIs](https://community.developer.battle.net/documentation/world-of-warcraft-classic/game-data-apis).

## Example API responses

**OAuth token (client credentials)**

```json
{
  "access_token": "USf2wExampleAccessTokenString",
  "token_type": "bearer",
  "expires_in": 86399,
  "scope": ""
}
```

**Playable class index**

```json
{
  "_links": {
    "self": {
      "href": "https://us.api.blizzard.com/data/wow/playable-class/index?namespace=static-classic-us&locale=en_US"
    }
  },
  "classes": [
    {
      "key": {
        "href": "https://us.api.blizzard.com/data/wow/playable-class/1?namespace=static-classic-us"
      },
      "name": "Warrior",
      "id": 1
    },
    {
      "key": {
        "href": "https://us.api.blizzard.com/data/wow/playable-class/2?namespace=static-classic-us"
      },
      "name": "Paladin",
      "id": 2
    }
    // ...
  ]
}
```

**Connected Realm API – Connected Realms Index**

- **Endpoint:** `GET /data/wow/connected-realm/index`
- **Description:** Returns an index of connected realms.

| Parameter  | Type   | Required | Value               | Description                                |
|------------|--------|----------|---------------------|--------------------------------------------|
| `:region`  | string | **Yes**  | `us`                | The region of the data to retrieve.        |
| `namespace`| string | **Yes**  | `dynamic-classic-us`| The namespace to use to locate this document. |
| `locale`   | string | No       | `en_US`             | The locale to reflect in localized data.   |

Region is supplied via the request host (e.g. `us.api.blizzard.com`). Our tests use `namespace=dynamic-classic-{region}` and optional `locale`.

Example response:

```json
{
  "_links": {
    "self": {
      "href": "https://us.api.blizzard.com/data/wow/connected-realm/index?namespace=dynamic-classic-us&locale=en_US"
    }
  },
  "connected_realms": [
    {
      "key": {
        "href": "https://us.api.blizzard.com/data/wow/connected-realm/123?namespace=dynamic-classic-us"
      },
      "id": 123
    }
  ]
}
```

#!/usr/bin/env python3
"""Manage LLM API keys for the shared llama-swap instance.

Usage:
  llm-auth-manage add <username>
  llm-auth-manage remove <username>
  llm-auth-manage rekey <username>
  llm-auth-manage list

Keys are hashed with PBKDF2-SHA256 before storage. The users.json file
can safely be world-readable.

For API access, pass the key as:  Authorization: Bearer sk-...
For web UI access, use the key as HTTP Basic Auth password.
"""
import hashlib
import hmac
import json
import os
import secrets
import sys

USERS_FILE = "/etc/llm-auth-secrets/users.json"


def load():
    if os.path.exists(USERS_FILE):
        with open(USERS_FILE) as f:
            return json.load(f)
    return {"users": {}}


def save(data):
    os.makedirs(os.path.dirname(USERS_FILE), mode=0o755, exist_ok=True)
    with open(USERS_FILE, "w") as f:
        json.dump(data, f, indent=2)
    os.chmod(USERS_FILE, 0o644)


def hash_key(key):
    salt = secrets.token_bytes(32)
    dk = hashlib.pbkdf2_hmac("sha256", key.encode(), salt, 100000)
    return salt.hex() + ":" + dk.hex()


def generate_key():
    return "sk-" + secrets.token_hex(24)


API_BASE_URL = "https://hive.van-duck.ts.net"
WEB_UI_URL = API_BASE_URL + "/ui/"
HURL_EXAMPLE_URL = (
    "https://github.com/mschwaig/nixos-config/tree/main/addins/llm/example.hurl"
)


def print_welcome_message(username, key):
    print()
    print("=" * 72)
    print(f"  LLM API access for: {username}")
    print("=" * 72)
    print()
    print("API Key (save this -- it will not be shown again):")
    print(f"  {key}")
    print()
    print("Base URL:")
    print(f"  {API_BASE_URL}")
    print()
    print("Web UI (log in with HTTP Basic Auth -- use your account name")
    print(f"       '{username}' as the username, and the API key as password):")
    print(f"  {WEB_UI_URL}")
    print()
    print("Authentication:")
    print("  Send the key as a bearer token for API calls:")
    print(f"    Authorization: Bearer {key}")
    print()
    print("The API is OpenAI-compatible. Relevant endpoints:")
    print(f"  GET  {API_BASE_URL}/v1/models")
    print(f"  POST {API_BASE_URL}/v1/chat/completions")
    print()
    print("Quick test with curl:")
    print(f'  curl -H "Authorization: Bearer {key}" \\')
    print(f'       {API_BASE_URL}/v1/models')
    print()
    print("Example requests (Hurl) are available here:")
    print(f"  {HURL_EXAMPLE_URL}")
    print(f"  Run with:  hurl --secret api_key={key} example.hurl")
    print()
    print("WARNING: This is a shared instance. Every request AND response")
    print("you send is visible to all other users who have been granted")
    print("access, both via the API and in the web UI (until the service")
    print("is restarted). Do not submit sensitive or private data.")
    print()
    print("If you lose this key, ask an admin to rekey your account.")
    print("=" * 72)


def cmd_add(username):
    data = load()
    if username in data["users"]:
        print(f"error: user '{username}' already exists", file=sys.stderr)
        sys.exit(1)
    key = generate_key()
    data["users"][username] = hash_key(key)
    save(data)
    print(f"User '{username}' added.")
    print_welcome_message(username, key)


def cmd_rekey(username):
    data = load()
    if username not in data["users"]:
        print(f"error: user '{username}' not found", file=sys.stderr)
        sys.exit(1)
    key = generate_key()
    data["users"][username] = hash_key(key)
    save(data)
    print(f"User '{username}' rekeyed.")
    print_welcome_message(username, key)


def cmd_remove(username):
    data = load()
    if username not in data["users"]:
        print(f"error: user '{username}' not found", file=sys.stderr)
        sys.exit(1)
    del data["users"][username]
    save(data)
    print(f"User '{username}' removed")


def cmd_list():
    data = load()
    if not data["users"]:
        print("(no users)")
        return
    for u in sorted(data["users"]):
        print(u)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    cmd = sys.argv[1]
    try:
        if cmd == "add" and len(sys.argv) == 3:
            cmd_add(sys.argv[2])
        elif cmd == "remove" and len(sys.argv) == 3:
            cmd_remove(sys.argv[2])
        elif cmd == "rekey" and len(sys.argv) == 3:
            cmd_rekey(sys.argv[2])
        elif cmd == "list":
            cmd_list()
        else:
            print(__doc__)
            sys.exit(1)
    except PermissionError as e:
        print(f"error: {e}", file=sys.stderr)
        print(f"Hint: does {USERS_FILE} or its parent directory exist?", file=sys.stderr)
        sys.exit(1)

#!/usr/bin/env python3
"""Auth service for Caddy forward_auth.

Validates Bearer tokens and Basic auth against /etc/llm-auth-secrets/users.json.
Returns 200/401 plus an X-Auth-User header that Caddy forwards upstream.
"""
import base64
import hashlib
import hmac
import json
import os
import sys
from http.server import HTTPServer, BaseHTTPRequestHandler

USERS_FILE = "/etc/llm-auth-secrets/users.json"


def load_users():
    try:
        with open(USERS_FILE) as f:
            return json.load(f).get("users", {})
    except Exception:
        return {}


def verify_key(key, stored):
    try:
        salt_hex, hash_hex = stored.split(":")
        salt = bytes.fromhex(salt_hex)
        expected = hashlib.pbkdf2_hmac("sha256", key.encode(), salt, 100000)
        return hmac.compare_digest(expected.hex(), hash_hex)
    except Exception:
        return False


def authenticate(auth_header):
    users = load_users()
    if not auth_header or not users:
        return None

    if auth_header.startswith("Bearer "):
        key = auth_header[7:]
        for username, stored in users.items():
            if verify_key(key, stored):
                return username

    elif auth_header.startswith("Basic "):
        try:
            decoded = base64.b64decode(auth_header[6:]).decode()
            username, key = decoded.split(":", 1)
        except Exception:
            return None
        if username in users and verify_key(key, users[username]):
            return username

    return None


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        auth = self.headers.get("Authorization", "")
        username = authenticate(auth)

        if username is None:
            self.send_response(401)
            self.send_header("Content-Type", "text/plain")
            self.end_headers()
            self.wfile.write(b"Unauthorized\n")
            return

        self.send_response(200)
        self.send_header("X-Auth-User", username)
        self.end_headers()

    def log_message(self, fmt, *args):
        print(f"auth-sidecar: {fmt % args}", file=sys.stderr)


if __name__ == "__main__":
    port = int(os.environ.get("PORT", "4180"))
    server = HTTPServer(("127.0.0.1", port), Handler)
    server.serve_forever()

# Example requests against the shared LLM API.
#
# The API key is injected via a Hurl secret so it never has to be committed
# and is redacted from logs. Run with:
#
#   hurl --secret api_key=sk-... example.hurl
#
# The value is available in the file as {{api_key}}.
# Base URL : https://hive.van-duck.ts.net
# Web UI   : https://hive.van-duck.ts.net/ui/
# Auth     : Authorization: Bearer <api_key>
#
# NOTE: every request and response sent to this shared instance is visible
# to all other users who have been granted access, both via the API and in
# the web UI (until the service is restarted). Do not send sensitive data.

GET https://hive.van-duck.ts.net/health
Authorization: Bearer {{api_key}}
HTTP 200

GET https://hive.van-duck.ts.net/v1/models
Authorization: Bearer {{api_key}}
HTTP 200

POST https://hive.van-duck.ts.net/v1/chat/completions
Authorization: Bearer {{api_key}}
Content-Type: application/json
{
  "model": "qwen3.5-27b",
  "messages": [{"role": "user", "content": "Hello!"}]
}
HTTP 200

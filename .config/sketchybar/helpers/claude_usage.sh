#!/bin/bash
# Fetch Claude usage limits from Anthropic's OAuth usage endpoint,
# authenticating with the Claude Code token stored in the macOS Keychain.
# Always prints JSON so the SbarLua exec callback receives a decoded table.

TOKEN=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null \
	| /usr/bin/python3 -c "import sys,json;print(json.load(sys.stdin)['claudeAiOauth']['accessToken'])" 2>/dev/null)

if [ -z "$TOKEN" ]; then
	echo '{"error":true}'
	exit 0
fi

RESPONSE=$(curl -sf --max-time 10 "https://api.anthropic.com/api/oauth/usage" \
	-H "Authorization: Bearer $TOKEN" \
	-H "anthropic-beta: oauth-2025-04-20") || {
	echo '{"error":true}'
	exit 0
}

echo "$RESPONSE"

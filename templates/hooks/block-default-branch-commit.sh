#!/usr/bin/env bash
# Claude Code PreToolUse hook (matcher: Bash).
# Blocks `git commit` while the current branch is the repository's default branch.
# Everything else passes through untouched.
#
# Install: copy to <repo>/.claude/hooks/ and wire it in .claude/settings.json
# (see settings-template.json). Exit code 2 tells Claude Code to block the call
# and feed the message on stderr back to the model.

set -u

input="$(cat)"

# Pull the command string out of the hook's JSON payload.
if command -v python3 >/dev/null 2>&1; then
  cmd="$(printf '%s' "$input" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null)"
else
  cmd="$(printf '%s' "$input" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p')"
fi

# Only care about commits.
case "$cmd" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac

current="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
[ -z "$current" ] && exit 0

# Default branch: from the remote HEAD if known, else main/master if they exist.
default="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')"
if [ -z "$default" ]; then
  for b in main master; do
    if git show-ref --verify --quiet "refs/heads/$b"; then default="$b"; break; fi
  done
fi
[ -z "$default" ] && exit 0

if [ "$current" = "$default" ]; then
  echo "Blocked: you are on the default branch ($default). Create or switch to a feature branch before committing." >&2
  exit 2
fi

exit 0

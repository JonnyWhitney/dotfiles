#!/usr/bin/env bash
#
# editor.sh — $EDITOR entry point for macOS.
#
# Invoked from a terminal: behaves exactly like `nvim`, opening in the current
# pane (e.g. `git commit` inside ghostty+zellij).
#
# Invoked by a graphical app (no controlling TTY): routes the edit into a
# running ghostty/zellij session as a new, file-titled tab — spawning a fresh
# ghostty running zellij if none is running — and blocks until neovim exits so
# the calling app reads the saved file.

set -euo pipefail

# Graphical launchers (Launch Services, AppleScript droplets) provide a bare
# PATH, so make sure the tools this script needs are resolvable.
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"

# A controlling TTY means we were launched from a terminal: keep current
# behavior and let neovim take over the pane.
if [[ -t 0 || -t 1 ]]; then
    exec nvim "$@"
fi

# --- Graphical launch: drive ghostty + zellij from outside any session. ---

# Tab title: the file being edited, or "nvim" when invoked with no arguments.
if (($# > 0)); then
    title="$(basename -- "${@: -1}")"
else
    title="nvim"
fi

# Reuse the most-recent live session if one exists. `-n` keeps the output
# parseable while still tagging exited sessions, which we filter out.
session="$(mise exec -- zellij list-sessions -n 2>/dev/null | grep -v 'EXITED' | head -1 | awk '{print $1}')"

# No live session: spawn a ghostty window running a dedicated zellij session
# and wait for the session to come up before driving it.
if [[ -z "$session" ]]; then
    session="edit"
    open -na Ghostty.app --args -e mise exec -- zellij attach -c "$session"
    for _ in $(seq 1 50); do
        if zellij list-sessions -ns 2>/dev/null | grep -qx "$session"; then
            break
        fi
        sleep 0.1
    done
fi

# Bring ghostty to the front, then open the edit in a new tab and block until
# neovim exits (correct $EDITOR semantics); the tab closes itself afterward.
open -a Ghostty
exec mise exec -- zellij --session "$session" action new-tab \
    --name "$title" --cwd "$PWD" --close-on-exit --block-until-exit \
    -- nvim "$@"

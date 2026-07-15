#!/bin/bash

set -u

lock_dir="${TMPDIR:-/tmp}/sketchybar-aerospace-mode-watcher"
pid_file="$lock_dir/pid"

acquire_lock() {
	if mkdir "$lock_dir" 2>/dev/null; then
		printf '%s\n' "$$" > "$pid_file"
		return 0
	fi

	local existing_pid
	existing_pid="$(cat "$pid_file" 2>/dev/null || true)"
	if [[ -n "$existing_pid" ]] && kill -0 "$existing_pid" 2>/dev/null; then
		return 1
	fi

	rm -rf "$lock_dir"
	mkdir "$lock_dir" 2>/dev/null || return 1
	printf '%s\n' "$$" > "$pid_file"
}

release_lock() {
	if [[ "$(cat "$pid_file" 2>/dev/null || true)" == "$$" ]]; then
		rm -rf "$lock_dir"
	fi
}

acquire_lock || exit 0
trap release_lock EXIT
trap 'exit 0' INT TERM

while true; do
	aerospace subscribe mode-changed 2>/dev/null |
		while IFS= read -r event; do
			mode="$(printf '%s\n' "$event" | sed -nE 's/.*"mode"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p')"
			if [[ -n "$mode" ]]; then
				sketchybar --trigger aerospace_mode_change MODE="$mode"
			fi
		done

	sleep 1
done

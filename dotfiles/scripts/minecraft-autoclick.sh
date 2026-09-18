#!/usr/bin/env bash
# Toggle: press once to start holding left click, press again to release.
# Only starts if Minecraft is the focused window, and auto-releases if
# focus moves away from Minecraft (e.g. alt-tab) so it never bleeds into
# other apps. Uses ydotool since it works at the /dev/uinput level and
# so is unaffected by niri/Wayland focus restrictions on synthetic input.
set -euo pipefail

pid_file="${XDG_RUNTIME_DIR:-/tmp}/minecraft-autoclick.pid"

is_minecraft_focused() {
	niri msg -j focused-window 2>/dev/null |
		jq -e '((.app_id // "") + " " + (.title // "")) | ascii_downcase | contains("minecraft")' >/dev/null
}

release() {
	ydotool click 0x80
}

if [ -f "$pid_file" ] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
	kill "$(cat "$pid_file")"
	rm -f "$pid_file"
	release
	exit 0
fi
rm -f "$pid_file"

if ! is_minecraft_focused; then
	echo "minecraft-autoclick: minecraft isn't focused, not starting" >&2
	exit 0
fi

(
	trap release EXIT TERM INT
	ydotool click 0x40
	while is_minecraft_focused; do
		sleep 0.3
	done
) &
disown

echo $! >"$pid_file"

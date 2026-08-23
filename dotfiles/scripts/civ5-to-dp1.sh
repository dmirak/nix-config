#!/usr/bin/env bash
# niri's open-on-output can't place Civ 5: it is an opening property, matched at
# the initial configure, but Proton's wayland driver sets app-id only after the
# toplevel maps. Poll for the window instead and move it once it shows up.
set -euo pipefail

for _ in $(seq 1 180); do
	id=$(niri msg -j windows |
		jq -r 'first(.[] | select(.app_id == "civilizationv_dx11.exe") | .id) // empty')
	if [ -n "$id" ]; then
		exec niri msg action move-window-to-monitor --id "$id" DP-1
	fi
	sleep 1
done

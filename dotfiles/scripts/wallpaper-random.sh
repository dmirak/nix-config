#!/usr/bin/env bash
# Picks a random wallpaper and applies it via noctalia's IPC `set` command,
# bypassing noctalia's built-in `wallpaper random` IPC call, which is broken
# when Multi-Monitor Directories is disabled (Screen.name is unresolved
# inside the WallpaperService singleton, so it silently no-ops).
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
  \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \))

if [ "${#wallpapers[@]}" -eq 0 ]; then
  echo "No wallpapers found in $WALLPAPER_DIR" >&2
  exit 1
fi

wallpaper="${wallpapers[RANDOM % ${#wallpapers[@]}]}"
# NixOS's noctalia-shell package wraps `qs` with QS_CONFIG_PATH baked in,
# so IPC calls target it directly rather than `qs -c noctalia-shell`.
exec noctalia-shell ipc call wallpaper set "$wallpaper" all

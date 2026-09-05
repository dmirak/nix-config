#!/usr/bin/env bash
# Software re-plug of the Audeze Maxwell dongle. The dongle re-enumerates on
# USB every time the headset powers on; if a stream grabs the ALSA device
# mid-cycle the card wedges and only a replug recovers it.
set -euo pipefail

vid=3329
pid=4b19

dev=""
for d in /sys/bus/usb/devices/*/; do
	[ -f "$d/idVendor" ] || continue
	[ "$(cat "$d/idVendor")" = "$vid" ] || continue
	[ "$(cat "$d/idProduct")" = "$pid" ] || continue
	dev=$d
	break
done

if [ -z "$dev" ]; then
	echo "maxwell dongle not found on usb" >&2
	exit 1
fi

echo "resetting $(basename "$dev")"
echo 0 | sudo tee "$dev/authorized" >/dev/null
sleep 2
echo 1 | sudo tee "$dev/authorized" >/dev/null

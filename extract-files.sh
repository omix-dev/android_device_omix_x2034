#!/usr/bin/env bash
#
# Refresh the OMIX X2034 proprietary blob tree from a connected device.
# Read-only on the device: only tar is used. Magisk's su allocates a pty,
# so "stty raw -echo" is required to keep binary data intact.
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DEST="$ROOT/vendor/omix/X2034/proprietary"
ADB="${ADB:-adb}"

if ! $ADB get-state >/dev/null 2>&1; then
    echo "error: no adb device" >&2
    exit 1
fi

if ! $ADB shell "su -c id" 2>/dev/null | grep -q 'uid=0'; then
    echo "error: root (su) is required to read the vendor partitions" >&2
    exit 1
fi

pull_part() {
    local part="$1"
    local out="$2"
    echo "==> /$part"
    mkdir -p "$out"
    $ADB exec-out "su -c 'stty raw -echo; tar -cf - -C /$part . 2>/dev/null'" \
        | tar -xpf - -C "$out"
}

pull_part vendor "$DEST/vendor"
pull_part vendor_dlkm "$DEST/vendor_dlkm"
pull_part odm_dlkm "$DEST/odm_dlkm"

echo "done: $DEST"

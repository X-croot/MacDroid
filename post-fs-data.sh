#!/system/bin/sh

STATE_DIR=/data/adb/macdroid
mkdir -p "$STATE_DIR"
chmod 0755 "$STATE_DIR"

# Migrate legacy v1 config location if present.
LEGACY=/data/adb/modules/macdroid/mac.conf
NEW="$STATE_DIR/mac.conf"

if [ -f "$LEGACY" ] && [ ! -f "$NEW" ]; then
    LEGACY_MAC=$(awk '{print $1}' "$LEGACY")
    LEGACY_IFACE=$(awk '{print $2}' "$LEGACY")
    if [ -n "$LEGACY_MAC" ] && [ -n "$LEGACY_IFACE" ]; then
        echo "$LEGACY_IFACE $LEGACY_MAC" > "$NEW"
        chmod 0644 "$NEW"
    fi
fi

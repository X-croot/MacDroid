#!/system/bin/sh

MODDIR=${0%/*}
STATE_DIR=/data/adb/macdroid
CONF_FILE="$STATE_DIR/mac.conf"
LOG_FILE="$STATE_DIR/boot.log"

mkdir -p "$STATE_DIR"
touch "$LOG_FILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "Service started (Magisk boot-complete stage)"

# Wait for network stack to settle. Some devices take 15-25s
# to bring wireless interfaces up after boot.
WAIT=0
MAX_WAIT=45
while [ $WAIT -lt $MAX_WAIT ]; do
    if [ -d /sys/class/net ] && ls /sys/class/net 2>/dev/null | grep -q .; then
        break
    fi
    sleep 1
    WAIT=$((WAIT + 1))
done
log "Network stack ready after ${WAIT}s"

sleep 3

if [ ! -f "$CONF_FILE" ]; then
    log "No persisted MAC config found. Nothing to apply."
    exit 0
fi

# Config file format (one entry per line):
#   <iface> <mac>
# Empty lines and lines starting with # are ignored.
while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
        ''|\#*) continue ;;
    esac

    IFACE=$(echo "$line" | awk '{print $1}')
    MAC=$(echo "$line" | awk '{print $2}')

    if [ -z "$IFACE" ] || [ -z "$MAC" ]; then
        continue
    fi

    if [ ! -e "/sys/class/net/$IFACE" ]; then
        log "Interface $IFACE not present, skipping"
        continue
    fi

    RETRY=0
    while [ $RETRY -lt 5 ]; do
        ip link set dev "$IFACE" down 2>>"$LOG_FILE"
        ip link set dev "$IFACE" address "$MAC" 2>>"$LOG_FILE"
        RESULT=$?
        ip link set dev "$IFACE" up 2>>"$LOG_FILE"

        CURRENT=$(cat "/sys/class/net/$IFACE/address" 2>/dev/null)
        if [ "$CURRENT" = "$MAC" ] || [ "$CURRENT" = "$(echo "$MAC" | tr 'A-Z' 'a-z')" ]; then
            log "Applied $MAC to $IFACE (attempt $((RETRY+1)))"
            break
        fi

        RETRY=$((RETRY + 1))
        sleep 2
    done

    if [ $RETRY -eq 5 ]; then
        log "FAILED to apply $MAC to $IFACE after 5 attempts"
    fi
done < "$CONF_FILE"

log "Service finished"

#!/system/bin/sh
MODDIR=${0%/*}
if [ -f /data/adb/modules/macdroid/mac.conf ]; then
    read savedmac iface < /data/adb/modules/macdroid/mac.conf
    ip link set dev $iface down
    ip link set dev $iface address $savedmac
    ip link set dev $iface up
fi

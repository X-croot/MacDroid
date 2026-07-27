#!/system/bin/sh

SKIPUNZIP=0

ui_print " "
ui_print "  ============================================"
ui_print "         MacDroid  -  MAC Address Suite"
ui_print "                  version 2.0"
ui_print "  ============================================"
ui_print " "
ui_print "  Advanced persistent MAC controller"
ui_print "  Multi-interface  |  Boot-safe  |  OUI DB"
ui_print " "

API=$(getprop ro.build.version.sdk)
ABI=$(getprop ro.product.cpu.abi)
ANDROID_VER=$(getprop ro.build.version.release)

ui_print "  Device info"
ui_print "    Android : $ANDROID_VER  (API $API)"
ui_print "    ABI     : $ABI"
ui_print " "

if [ "$API" -lt 23 ]; then
    ui_print "  ! Android 6.0 (API 23) or higher required."
    ui_print "  ! Detected API $API - aborting."
    abort
fi

ui_print "  Preparing module files ..."
mkdir -p "$MODPATH/system/bin"
mkdir -p "$MODPATH/system/etc/macdroid"
mkdir -p "$MODPATH/data"

ui_print "  Setting permissions ..."
set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/system/bin/macd"        0 2000 0755
set_perm "$MODPATH/service.sh"             0 0    0755
set_perm "$MODPATH/post-fs-data.sh"        0 0    0755
set_perm "$MODPATH/uninstall.sh"           0 0    0755

if [ ! -d /data/adb/macdroid ]; then
    mkdir -p /data/adb/macdroid
    chmod 0755 /data/adb/macdroid
fi

ui_print " "
ui_print "  Installation complete."
ui_print "  Reboot, then run:  su -c macd"
ui_print " "

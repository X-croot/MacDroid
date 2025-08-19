#!/system/bin/sh
MODDIR=${0%/*}
cp -f $MODDIR/system/bin/macd /system/bin/macd
chmod 755 /system/bin/macd

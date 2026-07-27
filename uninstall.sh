#!/system/bin/sh

# Runs when the user removes the module through Magisk.
# We keep the persisted config by default so a reinstall
# restores previous MACs. Users can wipe it manually:
#   rm -rf /data/adb/macdroid

# Remove any leftover legacy files in the module folder itself
# (safe: Magisk removes the module directory automatically).
:

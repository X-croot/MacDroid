# Changelog

## v2.0

### Fixes
- Rewrote `generate_random_mac`: v1 used bash brace expansion `{1..5}` which does not exist in Android's `/system/bin/sh` (`mksh`/`ash`), so random MACs were being generated as the literal string `{1..5}` — completely broken. New implementation is POSIX and uses `/dev/urandom`.
- Fixed argument-order inconsistency between the README, the interactive prompts, the direct commands, and the help output. Everything is now `set <iface> <mac>`.
- Replaced every `echo -e` with `printf` for portable escape-sequence handling.
- Boot service now waits for the network stack, retries up to 5 times with back-off, and logs each attempt.
- Magisk install path fixed: v1's `customize.sh` copied `macd` directly into `/system/bin` (violates the systemless principle and can persist a stale binary if the module is uninstalled). v2 uses the standard `$MODPATH/system/bin` overlay.
- `META-INF/com/google/android/update-binary` now uses the standard Magisk template with `install_module`, adding proper installer UI, SDK check, and versioned Magisk requirement.
- MAC format is now validated before being pushed to the kernel.

### New commands
- `status` — pretty overview of every interface with MAC, state, and type, plus a list of persisted rules.
- `show <iface>` — detailed per-interface panel (current MAC, vendor, type, state, original MAC, persisted MAC).
- `restore <iface>` — revert an interface to the MAC it had the first time MacDroid saw it, and drop the persistence rule.
- `unset <iface>` — remove persistence without touching the current MAC.
- `vendor <mac>` — OUI vendor lookup against a bundled compact database.
- `history` — last 50 changes with timestamps.
- `random <iface> oui` — keep the current vendor OUI, randomize only the last 24 bits.
- `random <iface> full` — full 48-bit random MAC.

### New under the hood
- `/data/adb/macdroid/` state directory:
  - `mac.conf` — one line per persisted rule.
  - `original.mac` — first-seen MAC per interface, for `restore`.
  - `history.log` — rolling log of the last 50 changes.
  - `boot.log` — timestamped boot-service log.
- Compact OUI vendor DB shipped at `/system/etc/macdroid/oui.db` (Apple, Samsung, Xiaomi, Google, Huawei, OnePlus, OPPO, Realme, Sony, Motorola, Intel, MediaTek, Qualcomm, Broadcom, VMware, VirtualBox, QEMU…).
- `post-fs-data.sh` migrates configs from v1's `/data/adb/modules/macdroid/mac.conf`.

### UI
- New banner, coloured 256-colour palette with graceful fallback when the terminal is not a TTY or when `NO_COLOR` is set.
- Numbered interface picker in the interactive menu (no more manually typing `wlan0`).
- Boxed section headers, tabular status output, consistent `[ ok ]` / `[fail]` / `[warn]` / `[info]` / `[step]` tags.

### Compatibility
- Verified to run on POSIX `sh` (mksh/ash) — Android 6.0 through Android 16.
- Minimum Magisk API set to 20400.

## v1.0
- Initial release: interactive menu, `set` / `show` / `random` / `apply` commands, single-interface persistence via `/data/adb/modules/macdroid/mac.conf`.

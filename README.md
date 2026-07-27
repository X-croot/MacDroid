# MacDroid

**Advanced MAC Address Suite for Android** — a lightweight, POSIX-clean Magisk module that gives you full control over your network interfaces' MAC addresses from a beautiful terminal UI. Works on **Android 6.0 through Android 16** on any rooted device.

```
   __  __            ____             _     _
  |  \/  | __ _  ___|  _ \ _ __ ___ (_) __| |
  | |\/| |/ _` |/ __| | | | '__/ _ \| |/ _` |
  | |  | | (_| | (__| |_| | | | (_) | | (_| |
  |_|  |_|\__,_|\___|____/|_|  \___/|_|\__,_|
```

---

## Features

- **`macd` command** — a colorful, boxed terminal interface with an interactive menu **and** scriptable commands.
- **True persistence** — saved MACs are re-applied automatically at every boot with retry logic that waits for the network stack to be ready.
- **Multi-interface** — persist rules for `wlan0`, `wlan1`, `eth0`, `rndis0`, hotspots, VPN tunnels — anything the kernel exposes.
- **Original-MAC backup** — the very first MAC observed on each interface is stored so you can always `restore` it.
- **Random MAC modes**
  - `laa` — random, but with the Locally Administered bit set (default, safest).
  - `oui` — keeps the current vendor OUI, randomizes only the NIC portion (useful for staying on captive-portal allow-lists that filter by vendor).
  - `full` — fully random 48 bits.
- **OUI vendor lookup** — bundled compact vendor database identifies Apple, Samsung, Xiaomi, Google, Huawei, Sony, OnePlus, OPPO, Realme, Motorola, Intel, MediaTek, Qualcomm, Broadcom and more; falls back to LAA detection.
- **Change history** — last 50 MAC changes are recorded with timestamps.
- **POSIX-safe** — no bash-only features (no `{1..5}`, no `[[ ]]`, no `echo -e`); the script runs under Android's `sh` (`mksh`/`ash`) on every Android version from Marshmallow to Baklava.
- **Systemless** — nothing is written to `/system`; all persisted state lives under `/data/adb/macdroid`.
- **Magisk-proper install** — uses the standard `install_module` flow, `set_perm_recursive`, and API/SDK checks.
- **Legacy migration** — automatically upgrades configs from MacDroid v1.

---

## Compatibility

| Android version | API level | Status |
|-----------------|-----------|--------|
| 6.0 Marshmallow | 23        | Supported |
| 7.x Nougat      | 24 – 25   | Supported |
| 8.x Oreo        | 26 – 27   | Supported |
| 9   Pie         | 28        | Supported |
| 10              | 29        | Supported |
| 11              | 30        | Supported |
| 12 / 12L        | 31 – 32   | Supported (see MAC randomization note) |
| 13              | 33        | Supported |
| 14              | 34        | Supported |
| 15              | 35        | Supported |
| 16 (Baklava)    | 36+       | Supported |

Requirements: **Magisk 20.4+**, root, and a kernel that allows `ip link set dev … address` (nearly every commercial Android kernel does).

> **Android 12–14 note.** The OS's own MAC randomization can override your setting at Wi-Fi association time. If that happens on your ROM, disable *Randomized MAC* inside the Wi-Fi network's advanced settings, or install a per-SSID randomization blocker (e.g. a hooking framework module). MacDroid still controls the interface at the kernel level — the OS just may re-randomize on top.

---

## Installation

1. Download `MacDroid.zip`.
2. Open **Magisk** → **Modules** → **Install from storage** → pick `MacDroid.zip`.
3. Reboot.
4. Open any terminal (Termux, adb shell, or the built-in shell), and run:

   ```sh
   su -c macd
   ```

The interactive menu will greet you.

---

## Command reference

```
macd                          # interactive menu
macd status                   # list all interfaces + persisted rules
macd show <iface>             # detailed info for one interface
macd set <iface> <mac>        # set custom MAC (also persisted)
macd random <iface> [mode]    # random MAC.  mode = laa | full | oui
macd apply                    # re-apply every persisted rule immediately
macd restore <iface>          # revert to original MAC + drop persistence
macd unset <iface>            # remove persistence but keep current MAC
macd vendor <mac>             # OUI vendor lookup
macd history                  # last 50 changes with timestamps
macd version                  # print version
macd help                     # full help screen
```

### Examples

```sh
# Show everything at a glance
macd status

# Randomize wlan0 with the safest strategy
macd random wlan0             # equivalent to: macd random wlan0 laa

# Randomize but keep the current vendor (helps on some captive portals)
macd random wlan0 oui

# Pin an explicit MAC
macd set wlan0 12:34:56:78:9A:BC

# Give me my real MAC back
macd restore wlan0
```

Every write operation is persisted automatically, so the same MAC is re-applied on the next boot.

---

## How persistence works

- On installation, MacDroid creates `/data/adb/macdroid/` for state.
- Every `set` / `random` writes a line into `/data/adb/macdroid/mac.conf`:

  ```
  wlan0 12:34:56:78:9A:BC
  eth0  02:AA:BB:CC:DD:EE
  ```

- At boot, Magisk's `post-fs-data.sh` migrates any legacy v1 config, and `service.sh` waits for the network stack, then re-applies every rule with 5 retries and 2-second back-off.
- The **very first** MAC ever observed for an interface is saved to `/data/adb/macdroid/original.mac` so `macd restore` can always undo everything.

---

## Uninstalling

Remove the module from Magisk and reboot. Your **persisted state is intentionally preserved** in `/data/adb/macdroid/` so that a reinstall picks up where you left off. To wipe it completely:

```sh
rm -rf /data/adb/macdroid
```

---

## Troubleshooting

**"Kernel refused the change"**
Wi-Fi drivers often lock the MAC while the radio is on. Toggle Wi-Fi off, run `macd set …`, then toggle Wi-Fi on.

**"Interface not found"**
Run `macd status` to see the exact interface names on your device. Not every Android calls its Wi-Fi `wlan0` — some use `wlp0s1`, `wifi0`, etc.

**Nothing happens at boot**
Check `/data/adb/macdroid/boot.log`. It records every boot-time apply attempt with timestamps and error messages.

**The MAC changes back on Android 12+**
This is the OS re-randomizing on top of your kernel-level change. See the *Android 12–14 note* above.

---

## Disclaimer

Changing MAC addresses can violate network policies and access controls. Random MACs default to the Locally Administered range so they don't collide with legitimate vendor OUIs. This software is provided **as-is** for educational and personal use. You are solely responsible for how you use it.

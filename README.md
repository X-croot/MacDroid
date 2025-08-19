# MacDroid (Magisk Module)

A minimal, fast, and colorful CLI to manage and persist custom MAC addresses on Android via Magisk. Includes an interactive TUI (`macd`) and boot‑time application of a saved MAC.

---

## Installation (Magisk)

1. Download `MacDroid.zip` to your device.
2. Open **Magisk** → **Modules** → **Install from storage** → select `MacDroid.zip`.
3. Reboot.

> Requires root/Magisk. Tested with Wi‑Fi interfaces like `wlan0`.

---

## CLI: `macd`

`macd` supports both interactive mode and direct command mode.

### Interactive Mode

```sh
macd
```

* Shows a menu to **Show**, **Set**, **Randomize**, or **Apply saved** MAC.

### Direct Commands

```sh
macd show <iface>
macd set <mac> <iface>
macd random <iface>
macd apply
macd help
```

#### Arguments

* `<iface>`: Network interface (e.g., `wlan0`).
* `<mac>`: MAC in `XX:XX:XX:XX:XX:XX` format.

#### Examples

```sh
# Show current MAC on wlan0
macd show wlan0

# Set a specific MAC on wlan0 and save it for reboot
macd set 12:34:56:78:9A:BC wlan0

# Generate and apply a random MAC on wlan0 (also saves it)
macd random wlan0

# Re-apply the last saved MAC (also done automatically on boot)
macd apply
```

---

## 🔁 Boot Behavior

* On boot, if a saved MAC exists, it is applied to the stored interface.
* If no MAC has been saved yet, **nothing is changed**.

---

## ⚖️ Disclaimer

Random MAC addresses default to Locally Administered (LAA). Do not spoof OUIs you do not own in environments where policy or compliance applies.

Changing your MAC address may affect network access controls (e.g., MAC filtering) and could violate network policies.

This software is provided strictly for educational and personal use only.

The user is solely responsible for any damages, disruptions, or legal consequences resulting from its use.

The developer cannot be held liable under any circumstances.

# Boot IDs Configuration

The script **automatically detects** boot IDs from your system's `efibootmgr` output. In most cases, no manual configuration is needed.

## How Automatic Detection Works

The script detects boot IDs by:

1. Searching for "Windows Boot Manager" to find the Windows boot ID
2. Searching for Linux/distro names (Linux, Ubuntu, Pop!\_OS, Debian, Fedora, Arch, etc.) to find the Linux boot ID
3. If Linux not found by name, using the first non-Windows entry from boot order
4. Only using fallback defaults (`0001` for Windows, `0004` for Linux) if all detection methods fail

## Troubleshooting

If the script shows a warning about using default boot IDs, or if boot configuration isn't working:

1. **Check your boot entries:**

   ```bash
   efibootmgr
   ```

2. **Verify the script detected them correctly:**
   The script shows detected boot IDs when it runs:

   ```
   🔍 Detected boot entries:
      Windows Boot Manager: Boot0001
      Linux: Boot0004
   ```

3. **If detection fails**, you can manually edit the fallback values in `src/restart-on-windows.sh`:

   ```bash
   # In the detect_boot_ids() function, around line 38-45
   if [ -z "$WINDOWS_BOOT_ID" ]; then
       WINDOWS_BOOT_ID="0001"  # Change to your Windows boot ID
   fi

   if [ -z "$LINUX_BOOT_ID" ]; then
       LINUX_BOOT_ID="0004"  # Change to your Linux boot ID
   fi
   ```

## Default Values

The script uses these defaults only if automatic detection fails:

- `0001` - Windows Boot Manager
- `0004` - Pop!\_OS 22.04 LTS (or first Linux entry found)

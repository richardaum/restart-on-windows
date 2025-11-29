# Restart on Windows

Scripts to easily restart your system and boot into Windows on a dual-boot Pop!\_OS setup.

## Installation

Install with one command:

```bash
curl -fsSL https://raw.githubusercontent.com/richardaum/restart-on-windows/main/install.sh | bash
```

Or using wget:

```bash
wget -qO- https://raw.githubusercontent.com/richardaum/restart-on-windows/main/install.sh | bash
```

This will:

- Download all necessary files to `~/.local/share/restart-on-windows`
- Run the automated installation script
- Set up everything automatically

## Files

- `restart-on-windows.sh` - Main script that configures boot and restarts into Windows
- `setup-restart-on-windows-sudo.sh` - Setup script to configure sudoers (run once)
- `restart-on-windows.desktop` - Desktop entry for the launcher
- `quick-start.sh` - Automated installation script
- `install.sh` - One-command installation script

## Quick Start

Run the automated installation script:

```bash
./quick-start.sh
```

This will:

- Install all scripts to `~/.local/bin/`
- Install the desktop entry
- Configure sudoers (you'll be prompted for your password once)
- Install `efibootmgr` if not already installed

After installation, you can use restart-on-windows from the launcher or terminal.

## Manual Installation

1. Create symbolic links to the scripts in your local bin directory:

   ```bash
   mkdir -p ~/.local/bin
   ln -sf "$(pwd)/restart-on-windows.sh" ~/.local/bin/restart-on-windows.sh
   ln -sf "$(pwd)/setup-restart-on-windows-sudo.sh" ~/.local/bin/setup-restart-on-windows-sudo.sh
   chmod +x restart-on-windows.sh
   chmod +x setup-restart-on-windows-sudo.sh
   ```

2. Create a symbolic link to the desktop entry:

   ```bash
   mkdir -p ~/.local/share/applications
   ln -sf "$(pwd)/restart-on-windows.desktop" ~/.local/share/applications/restart-on-windows.desktop
   update-desktop-database ~/.local/share/applications
   ```

3. Configure sudoers (run once, requires password):
   ```bash
   bash ~/.local/bin/setup-restart-on-windows-sudo.sh
   ```

## Usage

### From Launcher

Search for "Restart once on Windows" in your application launcher.

### From Terminal

```bash
# Temporary boot (default - returns to Pop!_OS after restart)
~/.local/bin/restart-on-windows.sh

# Permanent boot order change (Windows first)
~/.local/bin/restart-on-windows.sh --permanent

# Configure boot only, don't restart
~/.local/bin/restart-on-windows.sh --no-reboot

# Show help
~/.local/bin/restart-on-windows.sh --help
```

## Behavior

- **Default (temporary)**: Configures Windows for next boot only. After restarting, system returns to Pop!\_OS as default.
- **Permanent**: Changes boot order permanently. Windows becomes default until manually changed.

## Requirements

- `efibootmgr` package (usually pre-installed on Pop!\_OS)
- UEFI system with dual-boot Windows/Pop!\_OS
- Sudo access (only needed once for setup)

## Boot IDs

The script uses these boot IDs (from `efibootmgr`):

- `0001` - Windows Boot Manager
- `0004` - Pop!\_OS 22.04 LTS

If your boot IDs are different, edit the script and update `WINDOWS_BOOT_ID` and `POPOS_BOOT_ID` variables.

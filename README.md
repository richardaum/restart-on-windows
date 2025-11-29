# Restart on Windows

Scripts to easily restart your system and boot into Windows on a dual-boot Linux/Windows setup.

Works with various Linux distributions including Pop!\_OS, Ubuntu, Debian, Fedora, Arch, openSUSE, Mint, and others.

## Installation

Install with one command:

```bash
curl -fsSL https://raw.githubusercontent.com/richardaum/restart-on-windows/main/install.sh | bash
```

Or using wget:

```bash
wget -qO- https://raw.githubusercontent.com/richardaum/restart-on-windows/main/install.sh | bash
```

This will automatically:

- Download files from the main branch
- Install all necessary files to `~/.local/share/restart-on-windows`
- Set up symbolic links in `~/.local/bin/`
- Configure the desktop entry
- Set up sudoers (you'll be prompted for your password once)

## Quick Usage

### From Launcher

Search for "Restart once on Windows" in your application launcher.

### From Terminal

```bash
# Restart into Windows (temporary - returns to Linux after restart)
~/.local/bin/restart-on-windows.sh

# Show help
~/.local/bin/restart-on-windows.sh --help
```

## Requirements

- `efibootmgr` package (install with: `sudo apt install efibootmgr` or your distro's package manager)
- UEFI system with dual-boot Windows/Linux
- Sudo access (only needed once for setup)

## Supported Distributions

The script automatically detects boot entries for various Linux distributions:

- Pop!\_OS
- Ubuntu
- Debian
- Fedora
- Arch Linux
- openSUSE
- Linux Mint
- And other Linux distributions with UEFI boot entries

## Documentation

For more detailed information, see:

- **[Usage Guide](docs/usage.md)** - Detailed usage instructions and options
- **[Manual Installation](docs/manual-installation.md)** - Manual installation steps
- **[Boot IDs Configuration](docs/boot-ids.md)** - Configure custom boot IDs
- **[Testing](docs/testing.md)** - Information about the test suite

## Development

For development setup, testing, and contribution guidelines, see **[CONTRIBUTING.md](CONTRIBUTING.md)**.

Quick start:

- Install git hooks: `bash scripts/install-hooks.sh`
- Run tests: `bash tests/run_tests.sh`

## Files

- `restart-on-windows.sh` - Main script that configures boot and restarts into Windows
- `setup-restart-on-windows-sudo.sh` - Setup script to configure sudoers (run once)
- `restart-on-windows.desktop` - Desktop entry for the launcher
- `quick-start.sh` - Automated installation script
- `install.sh` - One-command installation script
- `scripts/install-hooks.sh` - Script to install git hooks for development

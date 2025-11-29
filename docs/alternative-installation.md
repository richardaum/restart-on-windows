# Alternative Installation Options

## Install a Specific Version

To install a specific release version (tag):

```bash
curl -fsSL https://raw.githubusercontent.com/richardaum/restart-on-windows/main/install.sh | bash -s v1.0.0
```

Replace `v1.0.0` with the version tag you want to install.

## Install Development Version

To install from the main branch (latest development code):

```bash
curl -fsSL https://raw.githubusercontent.com/richardaum/restart-on-windows/main/install.sh | bash -s main
```

**Note**: The development version may contain untested features or changes. Use at your own risk.

## Using Wget

If you prefer `wget` over `curl`:

```bash
# Latest stable
wget -qO- https://raw.githubusercontent.com/richardaum/restart-on-windows/main/install.sh | bash

# Specific version
wget -qO- https://raw.githubusercontent.com/richardaum/restart-on-windows/main/install.sh | bash -s v1.0.0

# Development version
wget -qO- https://raw.githubusercontent.com/richardaum/restart-on-windows/main/install.sh | bash -s main
```

## How Version Detection Works

The installer automatically:
1. Checks for the latest GitHub release tag
2. Falls back to `main` branch if no releases are found
3. Downloads files from the specified version/branch

## Updating

To update to the latest version, simply run the installation command again:

```bash
curl -fsSL https://raw.githubusercontent.com/richardaum/restart-on-windows/main/install.sh | bash
```

The installer will update your existing installation.


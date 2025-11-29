# Usage Guide

## From Launcher

Search for "Restart once on Windows" in your application launcher and click it.

## From Terminal

### Basic Usage

Restart into Windows temporarily (default - returns to Linux after restart):

```bash
~/.local/bin/restart-on-windows.sh
```

### Options

**Permanent boot order change** (Windows first):

```bash
~/.local/bin/restart-on-windows.sh --permanent
```

**Configure boot only, don't restart**:

```bash
~/.local/bin/restart-on-windows.sh --no-reboot
```

**Show help**:

```bash
~/.local/bin/restart-on-windows.sh --help
```

## Behavior

### Default (Temporary)

- Configures Windows for next boot only
- After restarting, system returns to Linux as default
- Safe option - doesn't permanently change boot order

### Permanent

- Changes boot order permanently
- Windows becomes default until manually changed
- Use with caution - you'll need to manually change back to Linux if desired

## Examples

**Temporary boot (recommended for most users)**:

```bash
~/.local/bin/restart-on-windows.sh
```

**Permanent boot order change**:

```bash
~/.local/bin/restart-on-windows.sh --permanent
```

**Configure boot but restart manually later**:

```bash
~/.local/bin/restart-on-windows.sh --no-reboot
```

# Manual Installation

If you prefer to install manually instead of using the automated installer:

## Step 1: Create Symbolic Links to Scripts

Create symbolic links to the scripts in your local bin directory:

```bash
mkdir -p ~/.local/bin
ln -sf "$(pwd)/src/restart-on-windows.sh" ~/.local/bin/restart-on-windows.sh
ln -sf "$(pwd)/src/setup-restart-on-windows-sudo.sh" ~/.local/bin/setup-restart-on-windows-sudo.sh
chmod +x src/restart-on-windows.sh
chmod +x src/setup-restart-on-windows-sudo.sh
```

## Step 2: Create Desktop Entry Link

Create a symbolic link to the desktop entry:

```bash
mkdir -p ~/.local/share/applications
ln -sf "$(pwd)/src/restart-on-windows.desktop" ~/.local/share/applications/restart-on-windows.desktop
update-desktop-database ~/.local/share/applications
```

## Step 3: Configure Sudoers

Configure sudoers to allow running restart-on-windows.sh without password (run once, requires password):

```bash
bash ~/.local/bin/setup-restart-on-windows-sudo.sh
```

## Benefits of Symbolic Links

Using symbolic links instead of copying files means:
- Any updates to the original files are automatically reflected
- No need to reinstall when files are updated
- Easier to maintain and update


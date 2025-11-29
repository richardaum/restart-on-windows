#!/bin/bash
# Script to restart the system into Windows
# Uses efibootmgr to set Windows Boot Manager as next boot
#
# BEHAVIOR: TEMPORARY (only for the next boot)
# After restarting into Windows, the system returns to default order (Pop!_OS first)
# To make it permanent, use: --permanent or -p

# Windows Boot Manager ID (Boot0001 according to efibootmgr)
WINDOWS_BOOT_ID="0001"
POPOS_BOOT_ID="0004"

# Check arguments
PERMANENT=false
NO_REBOOT=false

for arg in "$@"; do
    case "$arg" in
        --permanent|-p)
            PERMANENT=true
            ;;
        --no-reboot|-n)
            NO_REBOOT=true
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --permanent, -p    Permanently change boot order (Windows first)"
            echo "  --no-reboot, -n    Only configure boot, do not restart"
            echo "  --help, -h         Show this help"
            echo ""
            echo "Default behavior: Configure temporary boot and restart automatically"
            exit 0
            ;;
    esac
done

echo "🪟 Configuring restart into Windows..."
echo ""

# Check if efibootmgr is installed
if ! command -v efibootmgr &> /dev/null; then
    echo "❌ Error: efibootmgr is not installed."
    echo "   Install with: sudo apt install efibootmgr"
    exit 1
fi

# Check if running as root (required for efibootmgr)
if [ "$EUID" -ne 0 ]; then 
    # Try to run with sudo without password (if configured via sudoers)
    if sudo -n "$0" "$@" 2>/dev/null; then
        # sudo -n works (no password configured)
        exit $?
    else
        # Check if sudoers is configured
        if sudo -l "$0" 2>/dev/null | grep -q "NOPASSWD.*restart-windows.sh"; then
            # Sudoers configured but something went wrong, try again
            sudo "$0" "$@"
            exit $?
        else
            # Sudoers not configured - show instructions
            echo "⚠️  This script requires administrator privileges."
            echo ""
            echo "💡 To avoid entering password every time, configure sudoers by running:"
            echo "   bash ~/.local/bin/setup-restart-windows-sudo.sh"
            echo ""
            
            # Try to use pkexec in graphical environment (more user-friendly)
            if [ -n "$DISPLAY" ] && command -v pkexec &> /dev/null; then
                echo "   Opening authentication dialog..."
                echo ""
                pkexec "$0" "$@"
                exit $?
            else
                # Fallback: use normal sudo (will ask for password)
                echo "   Running with sudo (you will need to enter your password)..."
                echo ""
                sudo "$0" "$@"
                exit $?
            fi
        fi
    fi
fi

if [ "$PERMANENT" = true ]; then
    # Change permanent order: Windows first, then Pop!_OS
    echo "📝 Configuring Windows as PERMANENT default boot..."
    echo "   Previous order: $(efibootmgr | grep BootOrder)"
    efibootmgr -o "$WINDOWS_BOOT_ID,$POPOS_BOOT_ID,2001,0002,2002,2003"
    
    if [ $? -eq 0 ]; then
        echo "✅ Boot order changed permanently!"
        echo "   New order: $(efibootmgr | grep BootOrder)"
        echo ""
        echo "⚠️  WARNING: Windows will be the default boot until you change it manually."
        echo "   To return to Pop!_OS as default, run:"
        echo "   sudo efibootmgr -o $POPOS_BOOT_ID,$WINDOWS_BOOT_ID,2001,0002,2002,2003"
        echo ""
    else
        echo "❌ Error configuring boot. Check permissions."
        exit 1
    fi
else
    # Set Windows only for next boot (TEMPORARY)
    echo "📝 Setting Windows Boot Manager (Boot$WINDOWS_BOOT_ID) as next boot..."
    echo "   ⏱️  TEMPORARY: After restarting, returns to Pop!_OS as default"
    efibootmgr -n "$WINDOWS_BOOT_ID"
    
    if [ $? -eq 0 ]; then
        echo "✅ Configuration successful (temporary)!"
        echo ""
    else
        echo "❌ Error configuring boot. Check permissions."
        exit 1
    fi
fi

if [ "$NO_REBOOT" = true ]; then
    echo ""
    echo "✅ Boot configured successfully!"
    echo "   The system will NOT restart automatically."
    echo "   Restart manually when ready."
else
    echo ""
    echo "🔄 Restarting system in 5 seconds..."
    echo "   (Press Ctrl+C to cancel)"
    echo ""
    
    # Countdown
    for i in {5..1}; do
        echo -ne "\r   Restarting in $i second(s)...   "
        sleep 1
    done
    echo -e "\r   Restarting now...                    "
    echo ""
    
    # Check if systemctl reboot works
    if ! systemctl reboot 2>&1; then
        echo ""
        echo "⚠️  systemctl reboot failed. Trying alternative method..."
        
        # Try alternative method
        if command -v reboot &> /dev/null; then
            echo "   Using 'reboot' command..."
            reboot
        elif command -v shutdown &> /dev/null; then
            echo "   Using 'shutdown -r now' command..."
            shutdown -r now
        else
            echo "❌ Error: Could not restart the system automatically."
            echo "   Please restart manually."
            echo ""
            echo "✅ Boot has been configured for Windows on next restart."
            exit 1
        fi
    fi
fi


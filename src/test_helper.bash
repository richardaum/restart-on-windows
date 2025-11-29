#!/bin/bash
# Test helper functions and mocks

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Mock directories
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SRC_DIR/.." && pwd)"
MOCK_BIN_DIR="$PROJECT_ROOT/tests/mocks/bin"
MOCK_TMP_DIR="$PROJECT_ROOT/tests/mocks/tmp"

# Setup test environment
setup_test_env() {
    # Create mock directories
    mkdir -p "$MOCK_BIN_DIR"
    mkdir -p "$MOCK_TMP_DIR"
    
    # Add mock bin to PATH
    export PATH="$MOCK_BIN_DIR:$PATH"
    
    # Create mock efibootmgr
    create_mock_efibootmgr
    
    # Create mock sudo
    create_mock_sudo
    
    # Create mock systemctl
    create_mock_systemctl
    
    # Create mock commands
    create_mock_commands
}

# Cleanup test environment
cleanup_test_env() {
    rm -rf "$MOCK_BIN_DIR"
    rm -rf "$MOCK_TMP_DIR"
}

# Create mock efibootmgr
create_mock_efibootmgr() {
    cat > "$MOCK_BIN_DIR/efibootmgr" << 'EOF'
#!/bin/bash
# Mock efibootmgr

# Store commands for testing
echo "$@" >> "$MOCK_TMP_DIR/efibootmgr_calls.log"

# Simulate efibootmgr output
if [ "$1" = "-n" ]; then
    # Set next boot
    echo "BootNext: $2"
    exit 0
elif [ "$1" = "-o" ]; then
    # Set boot order
    echo "BootOrder: $2"
    exit 0
else
    # Default: show boot entries
    cat << 'BOOTENTRIES'
BootCurrent: 0004
Timeout: 0 seconds
BootOrder: 0004,0001,2001,0002,2002,2003
Boot0001* Windows Boot Manager
Boot0004* Pop!_OS 22.04 LTS
Boot2001* EFI USB Device
Boot2002* EFI DVD/CDROM
Boot2003* EFI Network
BOOTENTRIES
    exit 0
fi
EOF
    chmod +x "$MOCK_BIN_DIR/efibootmgr"
}

# Create mock sudo
create_mock_sudo() {
    cat > "$MOCK_BIN_DIR/sudo" << 'EOF'
#!/bin/bash
# Mock sudo - logs calls but doesn't require password

echo "$@" >> "$MOCK_TMP_DIR/sudo_calls.log"

# If -n flag (non-interactive), check if it would work
if [ "$1" = "-n" ]; then
    # Simulate NOPASSWD configured
    shift
    "$@"
    exit $?
fi

# If -l flag (list), simulate sudoers check
if [ "$1" = "-l" ]; then
    if grep -q "NOPASSWD" "$MOCK_TMP_DIR/sudoers_configured" 2>/dev/null; then
        echo "(ALL) NOPASSWD: $2"
        exit 0
    else
        exit 1
    fi
fi

# Otherwise, just execute the command
"$@"
exit $?
EOF
    chmod +x "$MOCK_BIN_DIR/sudo"
}

# Create mock systemctl
create_mock_systemctl() {
    cat > "$MOCK_BIN_DIR/systemctl" << 'EOF'
#!/bin/bash
# Mock systemctl

echo "$@" >> "$MOCK_TMP_DIR/systemctl_calls.log"

if [ "$1" = "reboot" ]; then
    echo "Mock: Would reboot system (not actually rebooting)"
    exit 0
fi

exit 0
EOF
    chmod +x "$MOCK_BIN_DIR/systemctl"
}

# Create other mock commands
create_mock_commands() {
    # Mock reboot
    cat > "$MOCK_BIN_DIR/reboot" << 'EOF'
#!/bin/bash
echo "Mock: Would reboot (not actually rebooting)"
echo "$@" >> "$MOCK_TMP_DIR/reboot_calls.log"
exit 0
EOF
    chmod +x "$MOCK_BIN_DIR/reboot"
    
    # Mock shutdown
    cat > "$MOCK_BIN_DIR/shutdown" << 'EOF'
#!/bin/bash
echo "Mock: Would shutdown (not actually shutting down)"
echo "$@" >> "$MOCK_TMP_DIR/shutdown_calls.log"
exit 0
EOF
    chmod +x "$MOCK_BIN_DIR/shutdown"
    
    # Mock pkexec
    cat > "$MOCK_BIN_DIR/pkexec" << 'EOF'
#!/bin/bash
echo "$@" >> "$MOCK_TMP_DIR/pkexec_calls.log"
# Simulate pkexec by just running the command
shift
"$@"
exit $?
EOF
    chmod +x "$MOCK_BIN_DIR/pkexec"
    
    # Mock visudo
    cat > "$MOCK_BIN_DIR/visudo" << 'EOF'
#!/bin/bash
if [ "$1" = "-c" ] && [ "$2" = "-f" ]; then
    # Check syntax
    if [ -f "$3" ]; then
        # Simple syntax check - just verify file exists
        exit 0
    else
        exit 1
    fi
fi
exit 0
EOF
    chmod +x "$MOCK_BIN_DIR/visudo"
    
    # Mock update-desktop-database
    cat > "$MOCK_BIN_DIR/update-desktop-database" << 'EOF'
#!/bin/bash
echo "$@" >> "$MOCK_TMP_DIR/update-desktop-database_calls.log"
exit 0
EOF
    chmod +x "$MOCK_BIN_DIR/update-desktop-database"
}

# Assert functions
assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="${3:-}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [ "$expected" = "$actual" ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $message"
        echo -e "  Expected: $expected"
        echo -e "  Actual:   $actual"
        return 1
    fi
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local message="${3:-}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    # Use -- to indicate end of options to avoid issues with patterns starting with -
    if echo "$haystack" | /usr/bin/grep -Fq -- "$needle" 2>/dev/null || echo "$haystack" | grep -Fq -- "$needle" 2>/dev/null; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $message"
        echo -e "  Expected to find: $needle"
        echo -e "  In: $haystack"
        return 1
    fi
}

assert_file_exists() {
    local file="$1"
    local message="${2:-File should exist: $file}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [ -f "$file" ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $message"
        return 1
    fi
}

assert_file_not_exists() {
    local file="$1"
    local message="${2:-File should not exist: $file}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [ ! -f "$file" ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $message"
        return 1
    fi
}

assert_exit_code() {
    local expected_code="$1"
    local actual_code="$2"
    local message="${3:-}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [ "$expected_code" -eq "$actual_code" ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $message"
        echo -e "  Expected exit code: $expected_code"
        echo -e "  Actual exit code:   $actual_code"
        return 1
    fi
}

# Print test summary
print_test_summary() {
    echo ""
    echo "=========================================="
    echo "Test Summary:"
    echo "  Total:  $TESTS_RUN"
    echo -e "  ${GREEN}Passed: $TESTS_PASSED${NC}"
    if [ $TESTS_FAILED -gt 0 ]; then
        echo -e "  ${RED}Failed: $TESTS_FAILED${NC}"
    else
        echo -e "  ${GREEN}Failed: $TESTS_FAILED${NC}"
    fi
    echo "=========================================="
    
    if [ $TESTS_FAILED -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# Clear mock logs
clear_mock_logs() {
    rm -f "$MOCK_TMP_DIR"/*.log 2>/dev/null
    rm -f "$MOCK_TMP_DIR"/sudoers_configured 2>/dev/null
}

# Setup sudoers as configured
setup_sudoers_configured() {
    touch "$MOCK_TMP_DIR/sudoers_configured"
    echo "NOPASSWD: /home/test/.local/bin/restart-on-windows.sh" > "$MOCK_TMP_DIR/sudoers_configured"
}

# Setup sudoers as not configured
setup_sudoers_not_configured() {
    rm -f "$MOCK_TMP_DIR/sudoers_configured"
}


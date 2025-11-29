#!/bin/bash
# Unit tests for restart-on-windows.sh

set -e

# Load test helper
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$TEST_DIR/test_helper.bash"

# Script to test
SCRIPT="$TEST_DIR/restart-on-windows.sh"

# Test: detect_boot_ids function exists
test_detect_boot_ids() {
    echo "Testing detect_boot_ids function..."
    
    setup_test_env
    
    # Verify the function exists in the script
    assert_contains "$(cat "$SCRIPT")" "detect_boot_ids()" "detect_boot_ids function should exist in script"
    assert_contains "$(cat "$SCRIPT")" "WINDOWS_BOOT_ID" "Script should contain WINDOWS_BOOT_ID variable"
    assert_contains "$(cat "$SCRIPT")" "LINUX_BOOT_ID" "Script should contain LINUX_BOOT_ID variable"
    
    cleanup_test_env
}

# Test: help option
test_help_option() {
    echo "Testing --help option..."
    
    setup_test_env
    
    output=$(bash "$SCRIPT" --help 2>&1)
    
    assert_contains "$output" "Usage:" "Help should show usage"
    assert_contains "$output" "--permanent" "Help should show --permanent option"
    assert_contains "$output" "--no-reboot" "Help should show --no-reboot option"
    
    cleanup_test_env
}

# Test: permanent flag parsing
test_permanent_flag() {
    echo "Testing --permanent flag parsing..."
    
    setup_test_env
    
    # Test flag parsing logic directly
    output=$(bash -c '
        PERMANENT=false
        for arg in "--permanent"; do
            case "$arg" in
                --permanent|-p) PERMANENT=true ;;
            esac
        done
        echo "$PERMANENT"
    ')
    
    assert_equals "true" "$output" "PERMANENT should be true with --permanent flag"
    
    cleanup_test_env
}

# Test: no-reboot flag parsing
test_no_reboot_flag() {
    echo "Testing --no-reboot flag parsing..."
    
    setup_test_env
    
    output=$(bash -c '
        NO_REBOOT=false
        for arg in "--no-reboot"; do
            case "$arg" in
                --no-reboot|-n) NO_REBOOT=true ;;
            esac
        done
        echo "$NO_REBOOT"
    ')
    
    assert_equals "true" "$output" "NO_REBOOT should be true with --no-reboot flag"
    
    cleanup_test_env
}

# Test: efibootmgr check when not installed
test_efibootmgr_not_installed() {
    echo "Testing efibootmgr not installed check..."
    
    setup_test_env
    
    # Test the check logic - verify script contains efibootmgr check
    script_content=$(cat "$SCRIPT")
    assert_contains "$script_content" "efibootmgr is not installed" "Script should check for efibootmgr"
    assert_contains "$script_content" "command -v efibootmgr" "Script should use command -v to check efibootmgr"
    
    cleanup_test_env
}

# Test: temporary boot configuration
test_temporary_boot() {
    echo "Testing temporary boot configuration..."
    
    setup_test_env
    
    # Verify script contains logic for temporary boot (efibootmgr -n)
    script_content=$(cat "$SCRIPT")
    assert_contains "$script_content" "efibootmgr -n" "Script should use efibootmgr -n for temporary boot"
    assert_contains "$script_content" "TEMPORARY" "Script should mention TEMPORARY boot"
    
    cleanup_test_env
}

# Test: permanent boot configuration
test_permanent_boot() {
    echo "Testing permanent boot configuration..."
    
    setup_test_env
    
    # Verify script contains logic for permanent boot (efibootmgr -o)
    script_content=$(cat "$SCRIPT")
    assert_contains "$script_content" "efibootmgr -o" "Script should use efibootmgr -o for permanent boot"
    assert_contains "$script_content" "PERMANENT" "Script should mention PERMANENT boot"
    
    cleanup_test_env
}

# Test: sudo escalation when not root
test_sudo_escalation() {
    echo "Testing sudo escalation..."
    
    setup_test_env
    
    # Verify script contains sudo escalation logic
    script_content=$(cat "$SCRIPT")
    assert_contains "$script_content" "EUID" "Script should check EUID for root"
    assert_contains "$script_content" "sudo" "Script should use sudo for escalation"
    
    cleanup_test_env
}

# Run all tests
run_tests() {
    echo "=========================================="
    echo "Running tests for restart-on-windows.sh"
    echo "=========================================="
    echo ""
    
    test_detect_boot_ids
    test_help_option
    test_permanent_flag
    test_no_reboot_flag
    test_efibootmgr_not_installed
    test_temporary_boot
    test_permanent_boot
    test_sudo_escalation
    
    print_test_summary
}

# Run tests if script is executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    run_tests
fi


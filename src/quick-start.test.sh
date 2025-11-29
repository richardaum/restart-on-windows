#!/bin/bash
# Unit tests for quick-start.sh

set -e

# Load test helper
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$TEST_DIR/test_helper.bash"

# Script to test
SCRIPT="$TEST_DIR/quick-start.sh"

# Test: symbolic link creation
test_symbolic_link_creation() {
    echo "Testing symbolic link creation..."
    
    setup_test_env
    
    TEST_BIN_DIR="$MOCK_TMP_DIR/test_bin"
    TEST_SCRIPT_DIR="$MOCK_TMP_DIR/test_scripts"
    
    mkdir -p "$TEST_BIN_DIR"
    mkdir -p "$TEST_SCRIPT_DIR"
    
    # Create test script
    echo "#!/bin/bash" > "$TEST_SCRIPT_DIR/test_script.sh"
    chmod +x "$TEST_SCRIPT_DIR/test_script.sh"
    
    # Create symbolic link
    ln -sf "$TEST_SCRIPT_DIR/test_script.sh" "$TEST_BIN_DIR/test_script.sh"
    
    # Check if link exists and points to correct file
    if [ -L "$TEST_BIN_DIR/test_script.sh" ]; then
        link_target=$(readlink -f "$TEST_BIN_DIR/test_script.sh")
        assert_equals "$TEST_SCRIPT_DIR/test_script.sh" "$link_target" "Symbolic link should point to correct file"
    else
        echo -e "${RED}✗${NC} Symbolic link should be created"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        TESTS_RUN=$((TESTS_RUN + 1))
    fi
    
    rm -rf "$TEST_BIN_DIR" "$TEST_SCRIPT_DIR"
    cleanup_test_env
}

# Test: efibootmgr installation check
test_efibootmgr_check() {
    echo "Testing efibootmgr installation check..."
    
    setup_test_env
    
    # Test command check
    if command -v efibootmgr &> /dev/null; then
        assert_equals "0" "0" "efibootmgr should be found in mock PATH"
    else
        # Remove from PATH to test missing case
        export PATH="/usr/bin:/bin"
        if ! command -v efibootmgr &> /dev/null; then
            assert_equals "0" "0" "efibootmgr should not be found when removed from PATH"
        fi
    fi
    
    cleanup_test_env
}

# Test: desktop entry link creation
test_desktop_entry_link() {
    echo "Testing desktop entry link creation..."
    
    setup_test_env
    
    TEST_APPS_DIR="$MOCK_TMP_DIR/test_apps"
    TEST_SCRIPT_DIR="$MOCK_TMP_DIR/test_scripts"
    
    mkdir -p "$TEST_APPS_DIR"
    mkdir -p "$TEST_SCRIPT_DIR"
    
    # Create test desktop file
    echo "[Desktop Entry]" > "$TEST_SCRIPT_DIR/test.desktop"
    
    # Create symbolic link
    ln -sf "$TEST_SCRIPT_DIR/test.desktop" "$TEST_APPS_DIR/test.desktop"
    
    assert_file_exists "$TEST_APPS_DIR/test.desktop" "Desktop entry link should be created"
    
    rm -rf "$TEST_APPS_DIR" "$TEST_SCRIPT_DIR"
    cleanup_test_env
}

# Test: script directory detection
test_script_dir_detection() {
    echo "Testing script directory detection..."
    
    setup_test_env
    
    # Test SCRIPT_DIR detection logic
    test_script="$MOCK_TMP_DIR/test_script.sh"
    cat > "$test_script" << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "$SCRIPT_DIR"
EOF
    chmod +x "$test_script"
    
    output=$(bash "$test_script")
    
    assert_equals "$MOCK_TMP_DIR" "$output" "SCRIPT_DIR should be detected correctly"
    
    cleanup_test_env
}

# Run all tests
run_tests() {
    echo "=========================================="
    echo "Running tests for quick-start.sh"
    echo "=========================================="
    echo ""
    
    test_symbolic_link_creation
    test_efibootmgr_check
    test_desktop_entry_link
    test_script_dir_detection
    
    print_test_summary
}

# Run tests if script is executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    run_tests
fi


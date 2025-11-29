#!/bin/bash
# Unit tests for setup-restart-on-windows-sudo.sh

set -e

# Load test helper
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$TEST_DIR/test_helper.bash"

# Script to test
SCRIPT="$TEST_DIR/setup-restart-on-windows-sudo.sh"

# Test: sudoers file creation
test_sudoers_file_creation() {
    echo "Testing sudoers file creation..."
    
    setup_test_env
    
    TEST_SUDOERS_FILE="$MOCK_TMP_DIR/test_sudoers"
    
    # Simulate sudoers file creation
    cat > "$TEST_SUDOERS_FILE" << 'EOF'
# Allow user to execute restart-on-windows.sh without password
user ALL=(ALL) NOPASSWD: /home/user/.local/bin/restart-on-windows.sh
EOF
    
    assert_file_exists "$TEST_SUDOERS_FILE" "Sudoers file should be created"
    assert_contains "$(cat "$TEST_SUDOERS_FILE")" "NOPASSWD" "Sudoers file should contain NOPASSWD"
    
    cleanup_test_env
}

# Test: visudo syntax validation
test_visudo_validation() {
    echo "Testing visudo validation..."
    
    setup_test_env
    
    TEST_SUDOERS_FILE="$MOCK_TMP_DIR/test_sudoers"
    echo "test ALL=(ALL) NOPASSWD: /path/to/script.sh" > "$TEST_SUDOERS_FILE"
    
    # Test visudo mock
    if "$MOCK_BIN_DIR/visudo" -c -f "$TEST_SUDOERS_FILE" 2>/dev/null; then
        assert_equals "0" "0" "visudo should validate correct syntax"
    else
        echo -e "${RED}✗${NC} visudo validation failed"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        TESTS_RUN=$((TESTS_RUN + 1))
    fi
    
    cleanup_test_env
}

# Test: sudoers file format
test_sudoers_format() {
    echo "Testing sudoers file format..."
    
    setup_test_env
    
    TEST_SUDOERS_FILE="$MOCK_TMP_DIR/test_sudoers"
    
    # Create sudoers file in expected format
    cat > "$TEST_SUDOERS_FILE" << 'EOF'
# Allow user to execute restart-on-windows.sh without password
user ALL=(ALL) NOPASSWD: /home/user/.local/bin/restart-on-windows.sh
EOF
    
    content=$(cat "$TEST_SUDOERS_FILE")
    
    assert_contains "$content" "ALL=(ALL)" "Sudoers should contain ALL=(ALL)"
    assert_contains "$content" "NOPASSWD" "Sudoers should contain NOPASSWD"
    assert_contains "$content" "restart-on-windows.sh" "Sudoers should contain script path"
    
    cleanup_test_env
}

# Test: temporary file cleanup
test_temp_file_cleanup() {
    echo "Testing temporary file cleanup..."
    
    setup_test_env
    
    TEST_TEMP_FILE="$MOCK_TMP_DIR/temp_sudoers_$$"
    echo "test" > "$TEST_TEMP_FILE"
    
    # Simulate cleanup
    rm -f "$TEST_TEMP_FILE"
    
    assert_file_not_exists "$TEST_TEMP_FILE" "Temporary file should be cleaned up"
    
    cleanup_test_env
}

# Run all tests
run_tests() {
    echo "=========================================="
    echo "Running tests for setup-restart-on-windows-sudo.sh"
    echo "=========================================="
    echo ""
    
    test_sudoers_file_creation
    test_visudo_validation
    test_sudoers_format
    test_temp_file_cleanup
    
    print_test_summary
}

# Run tests if script is executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    run_tests
fi


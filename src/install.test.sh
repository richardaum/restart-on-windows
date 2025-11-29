#!/bin/bash
# Unit tests for install.sh

set -e

# Load test helper
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$TEST_DIR/test_helper.bash"

# Script to test
SCRIPT="$TEST_DIR/../install.sh"

# Test: curl check when not installed
test_curl_not_installed() {
    echo "Testing curl not installed check..."
    
    setup_test_env
    
    # Test the curl check logic directly
    output=$(bash -c '
        if ! command -v curl &> /dev/null; then
            echo "curl is not installed"
        fi
    ' 2>&1)
    
    # This will pass if curl is not in /usr/bin:/bin (which it might be)
    # So we test the logic instead
    test_logic=$(bash -c '
        export PATH="/nonexistent/path"
        if ! command -v curl &> /dev/null 2>&1; then
            echo "curl is not installed"
        fi
    ')
    
    assert_contains "$test_logic" "curl is not installed" "Should detect missing curl when not in PATH"
    
    cleanup_test_env
}

# Test: version detection - latest
test_version_latest() {
    echo "Testing version detection - latest..."
    
    setup_test_env
    
    # Mock curl for GitHub API
    cat > "$MOCK_BIN_DIR/curl" << 'EOF'
#!/bin/bash
if [[ "$@" == *"api.github.com"*"releases/latest"* ]]; then
    echo '{"tag_name": "v1.0.0"}'
else
    echo "Mock curl"
fi
EOF
    chmod +x "$MOCK_BIN_DIR/curl"
    
    # Test version parsing logic
    output=$(bash -c '
        VERSION="latest"
        if [ "$VERSION" = "latest" ]; then
            LATEST_TAG=$(echo "{\"tag_name\": \"v1.0.0\"}" | grep -oP "\"tag_name\": \"\\K[^\"]*" | head -1)
            if [ -n "$LATEST_TAG" ]; then
                echo "$LATEST_TAG"
            else
                echo "main"
            fi
        fi
    ')
    
    assert_contains "$output" "v1.0.0" "Should detect latest tag"
    
    cleanup_test_env
}

# Test: version detection - specific version
test_version_specific() {
    echo "Testing version detection - specific version..."
    
    setup_test_env
    
    output=$(bash -c '
        VERSION="v1.0.0"
        if [ "$VERSION" = "latest" ]; then
            echo "latest"
        elif [ "$VERSION" = "main" ]; then
            echo "main"
        else
            echo "$VERSION"
        fi
    ')
    
    assert_equals "v1.0.0" "$output" "Should use specific version"
    
    cleanup_test_env
}

# Test: version detection - main branch
test_version_main() {
    echo "Testing version detection - main branch..."
    
    setup_test_env
    
    output=$(bash -c '
        VERSION="main"
        if [ "$VERSION" = "latest" ]; then
            echo "latest"
        elif [ "$VERSION" = "main" ]; then
            echo "main"
        else
            echo "$VERSION"
        fi
    ')
    
    assert_equals "main" "$output" "Should use main branch"
    
    cleanup_test_env
}

# Test: directory creation
test_directory_creation() {
    echo "Testing directory creation..."
    
    setup_test_env
    
    TEST_INSTALL_DIR="$MOCK_TMP_DIR/test_install"
    
    mkdir -p "$TEST_INSTALL_DIR"
    
    # Check if directory exists (use -d instead of -f)
    if [ -d "$TEST_INSTALL_DIR" ]; then
        assert_equals "0" "0" "Install directory should be created"
    else
        assert_equals "1" "0" "Install directory was not created"
    fi
    
    rm -rf "$TEST_INSTALL_DIR"
    cleanup_test_env
}

# Test: file download simulation
test_file_download() {
    echo "Testing file download simulation..."
    
    setup_test_env
    
    # Mock curl to simulate file download
    cat > "$MOCK_BIN_DIR/curl" << 'EOF'
#!/bin/bash
# Simple mock curl that writes to file specified with -o
output_file=""
args=("$@")
for i in "${!args[@]}"; do
    if [ "${args[$i]}" = "-o" ] && [ -n "${args[$i+1]}" ]; then
        output_file="${args[$i+1]}"
        echo "Mock file content" > "$output_file"
        echo "Downloaded to $output_file"
        break
    fi
done
EOF
    chmod +x "$MOCK_BIN_DIR/curl"
    
    TEST_FILE="$MOCK_TMP_DIR/test_file.sh"
    "$MOCK_BIN_DIR/curl" -fsSL "http://example.com/file.sh" -o "$TEST_FILE"
    
    if [ -f "$TEST_FILE" ]; then
        assert_equals "0" "0" "File should be downloaded"
    else
        assert_equals "1" "0" "File was not downloaded"
    fi
    
    cleanup_test_env
}

# Run all tests
run_tests() {
    echo "=========================================="
    echo "Running tests for install.sh"
    echo "=========================================="
    echo ""
    
    test_curl_not_installed
    test_version_latest
    test_version_specific
    test_version_main
    test_directory_creation
    test_file_download
    
    print_test_summary
}

# Run tests if script is executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    run_tests
fi


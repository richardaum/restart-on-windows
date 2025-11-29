#!/bin/bash
# Run all unit tests

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/../src"

echo "=========================================="
echo "Running All Unit Tests"
echo "=========================================="
echo ""

# Load test helper
source "$SRC_DIR/test_helper.bash"

# Track overall results
TOTAL_TESTS=0
TOTAL_PASSED=0
TOTAL_FAILED=0

# Run each test suite
test_files=(
    "restart-on-windows.test.sh"
    "quick-start.test.sh"
    "setup-restart-on-windows-sudo.test.sh"
    "install.test.sh"
)

for test_file in "${test_files[@]}"; do
    if [ -f "$SRC_DIR/$test_file" ]; then
        echo ""
        bash "$SRC_DIR/$test_file"
        result=$?
        
        if [ $result -eq 0 ]; then
            TOTAL_PASSED=$((TOTAL_PASSED + 1))
        else
            TOTAL_FAILED=$((TOTAL_FAILED + 1))
        fi
        TOTAL_TESTS=$((TOTAL_TESTS + 1))
    else
        echo "Warning: Test file $test_file not found"
    fi
done

# Print overall summary
echo ""
echo "=========================================="
echo "Overall Test Summary"
echo "=========================================="
echo "  Test Suites: $TOTAL_TESTS"
echo "  Passed:      $TOTAL_PASSED"
if [ $TOTAL_FAILED -gt 0 ]; then
    echo -e "  Failed:      ${RED}$TOTAL_FAILED${NC}"
    exit 1
else
    echo -e "  Failed:      ${GREEN}$TOTAL_FAILED${NC}"
    exit 0
fi


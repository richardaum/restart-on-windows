# Unit Tests

This directory contains unit tests for all scripts in the restart-on-windows project.

## Overview

The tests use a custom testing framework with mocks to ensure **no actual system changes** are made during testing. All system commands (efibootmgr, sudo, systemctl, reboot, etc.) are mocked.

## Test Structure

Test files are located in `src/` alongside their corresponding source files:

- `src/test_helper.bash` - Test framework, mocks, and assertion functions
- `src/restart-on-windows.test.sh` - Tests for the main restart script
- `src/install.test.sh` - Tests for the installation script
- `src/quick-start.test.sh` - Tests for the quick-start script
- `src/setup-restart-on-windows-sudo.test.sh` - Tests for the sudoers setup script
- `tests/run_tests.sh` - Script to run all tests
- `tests/mocks/` - Mock directories for test execution

## Running Tests

### Run All Tests

```bash
cd tests
bash run_tests.sh
```

### Run Individual Test Suites

```bash
# Test restart-on-windows.sh
bash src/restart-on-windows.test.sh

# Test install.sh
bash src/install.test.sh

# Test quick-start.sh
bash src/quick-start.test.sh

# Test setup-restart-on-windows-sudo.sh
bash src/setup-restart-on-windows-sudo.test.sh
```

## How Tests Work

### Mocks

All system commands are mocked in `test_helper.bash`:

- **efibootmgr** - Simulates boot configuration without actually changing boot order
- **sudo** - Simulates sudo without requiring password
- **systemctl** - Simulates systemctl commands without actually rebooting
- **reboot/shutdown** - Logs calls but doesn't actually reboot
- **pkexec** - Simulates graphical authentication
- **visudo** - Validates sudoers syntax without modifying system files

### Test Environment

Each test:

1. Sets up a temporary test environment
2. Creates mock commands in a temporary directory
3. Adds mocks to PATH
4. Runs the script being tested
5. Verifies expected behavior using assertions
6. Cleans up the test environment

### Assertions

Available assertion functions:

- `assert_equals expected actual "message"` - Check if two values are equal
- `assert_contains haystack needle "message"` - Check if string contains substring
- `assert_file_exists file "message"` - Check if file exists
- `assert_file_not_exists file "message"` - Check if file doesn't exist
- `assert_exit_code expected actual "message"` - Check exit code

## What Gets Tested

### restart-on-windows.sh

- Boot ID detection
- Command-line argument parsing (--help, --permanent, --no-reboot)
- efibootmgr availability check
- Temporary vs permanent boot configuration
- Sudo escalation logic

### install.sh

- curl availability check
- Version detection (latest, specific version, main branch)
- Directory creation
- File download simulation

### quick-start.sh

- Symbolic link creation
- efibootmgr installation check
- Desktop entry link creation
- Script directory detection

### setup-restart-on-windows-sudo.sh

- Sudoers file creation
- visudo syntax validation
- Sudoers file format
- Temporary file cleanup

## Safety

**All tests are completely safe** - they use mocks and temporary directories. No actual system changes are made:

- No boot configuration changes
- No sudoers modifications
- No system reboots
- No file system changes outside test directories

## Adding New Tests

To add a new test:

1. Create a test function: `test_something() { ... }`
2. Use setup_test_env at the start
3. Use cleanup_test_env at the end
4. Use assertion functions to verify behavior
5. Add the test function to `run_tests()` in the test file

Example:

```bash
test_new_feature() {
    echo "Testing new feature..."

    setup_test_env

    # Your test code here
    assert_equals "expected" "actual" "Test message"

    cleanup_test_env
}
```

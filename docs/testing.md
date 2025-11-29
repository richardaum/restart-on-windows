# Testing

This project includes unit tests that use mocks to safely test all scripts without affecting your system.

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

## Test Safety

**All tests are completely safe** - they use mocks and temporary directories. No actual system changes are made:

- ✅ No boot configuration changes
- ✅ No sudoers modifications
- ✅ No system reboots
- ✅ No file system changes outside test directories

## Test Framework

The tests use a custom framework (`src/test_helper.bash`) that:

- Mocks all system commands (efibootmgr, sudo, systemctl, reboot, etc.)
- Creates isolated test environments
- Provides assertion functions for verification
- Cleans up after each test

## What Gets Tested

- Command-line argument parsing
- Boot ID detection
- Dependency checks (efibootmgr, curl)
- Symbolic link creation
- Sudo escalation logic
- File format validation

For more details, see [`tests/README.md`](../tests/README.md).

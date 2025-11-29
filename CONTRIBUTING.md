# Contributing

Thank you for your interest in contributing to restart-on-windows!

## Available Commands

Quick reference for development commands:

```bash
# Git Hooks
bash scripts/install-hooks.sh          # Install git hooks

# Testing
bash tests/run_tests.sh                # Run all tests
```

For detailed testing information, see [Testing Documentation](docs/testing.md).

## Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/richardaum/restart-on-windows.git
cd restart-on-windows
```

### 2. Install Git Hooks

Install git hooks to automatically run tests before pushing:

```bash
bash scripts/install-hooks.sh
```

This will install hooks from `.githooks/` to `.git/hooks/`. The `pre-push` hook will automatically run tests before allowing a push.

**What this does:**

- Copies hooks from `.githooks/` to `.git/hooks/`
- Makes hooks executable
- Ensures tests run automatically before each push

## Running Tests

For detailed information about running tests, see [Testing Documentation](docs/testing.md).

Quick start:

```bash
bash tests/run_tests.sh
```

## Git Hooks

### What are Git Hooks?

Git hooks are scripts that run automatically at certain points in the git workflow. This project uses:

- **pre-push**: Runs tests before allowing a push to remote

### Installing Hooks

Run the installation script:

```bash
bash scripts/install-hooks.sh
```

### How Hooks Work

1. Hooks are stored in `.githooks/` (versioned in git)
2. The install script copies them to `.git/hooks/` (where git looks for hooks)
3. Git automatically executes hooks at the appropriate times
4. If a hook fails (e.g., tests fail), the operation is blocked

### Bypassing Hooks (Not Recommended)

If you need to bypass hooks (e.g., for emergency fixes), you can use:

```bash
git push --no-verify
```

**Warning**: Only bypass hooks if absolutely necessary. Tests exist to prevent bugs.

## Adding New Tests

For information about the test framework, assertions, and how to add new tests, see [Testing Documentation](docs/testing.md).

## Code Style

- Use consistent indentation (spaces, not tabs)
- Follow existing code style in the project
- Add comments for complex logic
- Keep functions focused and small

## Submitting Changes

1. Make your changes
2. Run tests to ensure everything passes
3. Commit your changes
4. Push (hooks will run tests automatically)
5. Create a pull request

## Questions?

For more information, see:

- [Testing Documentation](docs/testing.md)
- [Usage Guide](docs/usage.md)
- [README](README.md)

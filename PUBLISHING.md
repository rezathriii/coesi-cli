# COESI CLI - Publishing to PyPI Guide

This guide walks you through the process of publishing the COESI CLI to PyPI so it can be installed globally with `pip install coesi`.

## Prerequisites

1. **PyPI Account**: Create accounts on both:
   - [TestPyPI](https://test.pypi.org/account/register/) (for testing)
   - [PyPI](https://pypi.org/account/register/) (for production)

2. **API Tokens**: Generate API tokens for both platforms:
   - Go to Account Settings → API tokens
   - Create a new token with "Entire account" scope
   - Save the tokens securely

## Step-by-Step Publishing Process

### 1. Prepare the Package

```bash
# Ensure all dependencies are installed
pip install build twine

# Update version in pyproject.toml if needed
# Test locally
pip install -e .
coesi --help
```

### 2. Run Tests and Quality Checks

```bash
# Run all tests
pytest

# Format code
black src/ tests/

# Check code quality
flake8 src/ tests/

# Type checking
mypy src/
```

### 3. Build the Package

```bash
# Clean previous builds
rm -rf dist/ build/ *.egg-info/

# Build wheel and source distribution
python -m build

# Verify build contents
ls -la dist/
```

### 4. Test on TestPyPI (Recommended)

```bash
# Upload to TestPyPI first
twine upload --repository testpypi dist/*

# Test installation from TestPyPI
pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ coesi

# Test the CLI
coesi --help
```

### 5. Publish to Production PyPI

```bash
# Upload to production PyPI
twine upload dist/*
```

### 6. Verify Installation

```bash
# Install from PyPI
pip install coesi

# Test global installation
coesi --version
coesi --help
```

## Using the Automated Script

We've provided a `publish.sh` script that automates this process:

```bash
# Setup development environment
./publish.sh setup

# Run full development cycle (test, format, build)
./publish.sh all

# Publish to TestPyPI
./publish.sh test-pub

# Publish to production PyPI
./publish.sh publish
```

## Configuration Files for PyPI

### `.pypirc` (optional)

Create `~/.pypirc` to store repository URLs:

```ini
[distutils]
index-servers = pypi testpypi

[pypi]
repository = https://upload.pypi.org/legacy/
username = __token__

[testpypi]
repository = https://test.pypi.org/legacy/
username = __token__
```

### Environment Variables

Set these environment variables for automation:

```bash
export TWINE_USERNAME=__token__
export TWINE_PASSWORD=pypi-your-token-here  # Production token
export TWINE_REPOSITORY_URL=https://upload.pypi.org/legacy/
```

## Version Management

Update version numbers in `pyproject.toml`:

```toml
[project]
name = "coesi"
version = "0.1.1"  # Increment this for each release
```

## Package Naming Considerations

- The package name `coesi` must be unique on PyPI
- If the name is taken, consider alternatives like:
  - `coesi-cli`
  - `coesi-platform`
  - `coesi-deploy`

## Post-Publication

After publishing to PyPI:

1. **Test Installation**: Install on a clean system to verify
2. **Update Documentation**: Update README with installation instructions
3. **Create Release**: Tag the version in your Git repository
4. **Monitor**: Check PyPI download statistics and user feedback

## Common Issues and Solutions

### Authentication Errors
- Verify API tokens are correct
- Ensure you're using `__token__` as username
- Check repository URLs in configuration

### Package Name Conflicts
- Choose a unique package name
- Consider adding a prefix/suffix to avoid conflicts

### Build Errors
- Ensure all dependencies are properly specified
- Check `pyproject.toml` configuration
- Verify Python version compatibility

### Upload Errors
- Don't upload the same version twice
- Increment version number for each upload
- Clean build artifacts between uploads

## Example Workflow

```bash
# 1. Development cycle
git checkout -b feature/new-feature
# ... make changes ...
pytest  # Ensure tests pass

# 2. Prepare release
git checkout main
git merge feature/new-feature
# Update version in pyproject.toml
git commit -am "Bump version to 0.1.1"
git tag v0.1.1

# 3. Build and test
./publish.sh build
./publish.sh test-pub

# 4. Production release
./publish.sh publish
git push origin main --tags
```

This process ensures your COESI CLI is properly tested and distributed to users worldwide!

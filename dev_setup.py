#!/usr/bin/env python3
"""
Setup script for COESI CLI development and publishing.
"""

import subprocess
import sys
from pathlib import Path

def run_command(cmd, description):
    """Run a command and handle errors."""
    print(f"\n🔄 {description}...")
    try:
        subprocess.run(cmd, shell=True, check=True)
        print(f"✅ {description} completed successfully")
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} failed: {e}")
        sys.exit(1)

def main():
    """Main setup script."""
    print("🚀 COESI CLI Development Setup")
    print("=" * 40)
    
    # Check if we're in a virtual environment
    if sys.prefix == sys.base_prefix:
        print("⚠️  Warning: Not in a virtual environment")
        print("It's recommended to run this in a virtual environment")
        response = input("Continue anyway? (y/N): ")
        if response.lower() != 'y':
            sys.exit(0)
    
    # Install package in development mode
    run_command("pip install -e .", "Installing package in development mode")
    
    # Install development dependencies
    run_command("pip install -e .[dev]", "Installing development dependencies")
    
    # Run tests
    run_command("pytest", "Running tests")
    
    # Format code
    run_command("black src/", "Formatting code with Black")
    
    # Check code quality
    run_command("flake8 src/", "Checking code quality with Flake8")
    
    # Type checking
    run_command("mypy src/", "Running type checks with MyPy")
    
    print("\n🎉 Setup completed successfully!")
    print("\nYou can now run the CLI with: coesi --help")
    print("\nTo publish to PyPI:")
    print("1. Update version in pyproject.toml")
    print("2. Run: python -m build")
    print("3. Run: twine upload dist/*")

if __name__ == "__main__":
    main()

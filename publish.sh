#!/bin/bash

# COESI CLI Publishing Script
# This script helps build and publish the COESI CLI to PyPI

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command_exists python3; then
        print_error "Python 3 is not installed"
        exit 1
    fi
    
    if ! command_exists pip; then
        print_error "pip is not installed"
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Setup development environment
setup_dev() {
    print_status "Setting up development environment..."
    
    # Create virtual environment if it doesn't exist
    if [ ! -d ".venv" ]; then
        print_status "Creating virtual environment..."
        python3 -m venv .venv
    fi
    
    # Activate virtual environment
    print_status "Activating virtual environment..."
    source .venv/bin/activate
    
    # Upgrade pip
    print_status "Upgrading pip..."
    pip install --upgrade pip
    
    # Install package in development mode
    print_status "Installing package in development mode..."
    pip install -e .[dev]
    
    print_success "Development environment setup complete"
}

# Run tests
run_tests() {
    print_status "Running tests..."
    
    # Activate virtual environment
    source .venv/bin/activate
    
    # Run pytest
    pytest --cov=coesi --cov-report=term-missing
    
    print_success "Tests completed"
}

# Format and lint code
format_code() {
    print_status "Formatting and linting code..."
    
    # Activate virtual environment
    source .venv/bin/activate
    
    # Format with black
    print_status "Formatting with Black..."
    black src/ tests/
    
    # Lint with flake8
    print_status "Linting with Flake8..."
    flake8 src/ tests/
    
    # Type check with mypy
    print_status "Type checking with MyPy..."
    mypy src/
    
    print_success "Code formatting and linting complete"
}

# Build package
build_package() {
    print_status "Building package..."
    
    # Activate virtual environment
    source .venv/bin/activate
    
    # Clean previous builds
    rm -rf dist/ build/ *.egg-info/
    
    # Build package
    python -m build
    
    print_success "Package built successfully"
    print_status "Built files:"
    ls -la dist/
}

# Publish to TestPyPI
publish_test() {
    print_status "Publishing to TestPyPI..."
    
    # Activate virtual environment
    source .venv/bin/activate
    
    # Upload to TestPyPI
    twine upload --repository testpypi dist/*
    
    print_success "Published to TestPyPI"
    print_status "You can test install with:"
    print_status "pip install --index-url https://test.pypi.org/simple/ coesi"
}

# Publish to PyPI
publish_pypi() {
    print_status "Publishing to PyPI..."
    
    print_warning "This will publish to the production PyPI repository!"
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Publishing cancelled"
        exit 0
    fi
    
    # Activate virtual environment
    source .venv/bin/activate
    
    # Upload to PyPI
    twine upload dist/*
    
    print_success "Published to PyPI"
    print_status "Package is now available at: https://pypi.org/project/coesi/"
}

# Show help
show_help() {
    echo "COESI CLI Development and Publishing Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  setup     - Setup development environment"
    echo "  test      - Run tests"
    echo "  format    - Format and lint code"
    echo "  build     - Build package for distribution"
    echo "  test-pub  - Publish to TestPyPI"
    echo "  publish   - Publish to PyPI (production)"
    echo "  all       - Run setup, test, format, and build"
    echo "  help      - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 setup           # Setup development environment"
    echo "  $0 all             # Complete development cycle"
    echo "  $0 test-pub        # Publish to TestPyPI for testing"
    echo "  $0 publish         # Publish to production PyPI"
}

# Main script logic
case "${1:-help}" in
    setup)
        check_prerequisites
        setup_dev
        ;;
    test)
        run_tests
        ;;
    format)
        format_code
        ;;
    build)
        build_package
        ;;
    test-pub)
        build_package
        publish_test
        ;;
    publish)
        build_package
        publish_pypi
        ;;
    all)
        check_prerequisites
        setup_dev
        run_tests
        format_code
        build_package
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac

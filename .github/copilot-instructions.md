<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# COESI CLI Project Instructions

This is a Python CLI tool project for managing COESI Platform Docker deployments.

## Project Structure
- `src/cli.py` - Main CLI interface using Click framework
- `src/utils.py` - Utility functions for Docker operations, IP validation, etc.
- `pyproject.toml` - Modern Python packaging configuration
- `README.md` - Project documentation

## Key Technologies
- **Click** - Command line interface framework
- **Rich** - Terminal formatting and colors
- **Docker Python SDK** - Docker operations
- **python-dotenv** - Environment file management

## Development Guidelines
1. Use Click for all CLI commands and options
2. Use Rich for colored console output and formatting
3. Follow PEP 8 style guidelines
4. Include type hints for all functions
5. Use docstrings for all modules, classes, and functions
6. Handle errors gracefully with informative messages

## CLI Commands Structure
The CLI replicates bash script functionality:
- `coesi dev` - Deploy development (localhost only)
- `coesi prod [IP]` - Deploy production with optional IP
- `coesi restart [profile]` - Restart services
- `coesi stop [profile]` - Stop services
- `coesi status [profile]` - Show status
- `coesi logs [service]` - View logs
- `coesi clean [profile]` - Clean containers/volumes
- `coesi ip [address]` - Update production IP

## Docker Integration
- Uses docker-compose for orchestration
- Supports dev/prod profiles
- Validates Docker availability before operations
- Manages environment files (.env.dev, .env.prod)

## Error Handling
- Validate Docker installation and daemon
- Validate IP addresses with proper ranges
- Check environment files exist and have required variables
- Provide clear error messages with Rich formatting

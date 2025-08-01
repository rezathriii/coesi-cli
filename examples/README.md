# COESI CLI Example Docker Compose Configuration

This directory contains example configuration files that show how to set up your
COESI project to work with the CLI tool.

## Files

### `.env.dev`
Development environment configuration with localhost settings.

### `.env.prod` 
Production environment configuration with default production IP.

## Usage

1. Copy these files to your COESI project root directory
2. Modify the IP addresses and ports as needed for your environment
3. Use the CLI commands:

```bash
# Deploy development
coesi dev

# Deploy production
coesi prod

# Deploy production with custom IP
coesi prod 10.0.0.100
```

## Requirements

Your COESI project should have:
- `docker-compose.yml` file with dev and prod profiles
- `.env.dev` and `.env.prod` files (use examples as templates)
- Docker and Docker Compose installed

## Example docker-compose.yml profiles

```yaml
services:
  graphdb:
    profiles: ["dev", "prod"]
    # ... service configuration
    
  core-api:
    profiles: ["dev", "prod"]
    # ... service configuration
```

This ensures services are deployed only when the appropriate profile is selected.

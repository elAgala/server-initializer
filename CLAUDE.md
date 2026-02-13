# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Server-initializer is a Docker-based server setup automation tool that provisions Ubuntu/Debian servers with a complete web infrastructure stack including:
- Caddy web server with WAF (Coraza) and CrowdSec protection
- Prometheus, Loki, Grafana monitoring stack
- User management and SSH configuration
- Docker containers with proper networking

## Common Commands

### Development and Testing
```bash
# Build and test setup script in development mode (skips Docker operations)
make dev

# Build and keep container alive for testing
make dev-keep-alive

# Build Docker test container  
make build

# Clean up test containers and images
make clean

# Build custom Caddy image with WAF and CrowdSec (includes push to registry)
make build-caddy
```

The `--development` flag can be passed to `install.sh` to skip Docker-related operations during testing.

### Caddy Management (from deployed server)
These commands should be run from within the `templates/caddy/full/` directory on the deployed server:

```bash
# Restart Caddy with config reload  
make caddy:restart

# Generate new CrowdSec API key
make caddy:crowdsec-key

# Generate password hash for authentication
make caddy:generate-password

# View Caddy logs
make caddy:logs
```

## Architecture

### Entry Points
- `index.sh` - Main entry point that clones repo and runs `install.sh`
- `install.sh` - Master installer that orchestrates all component installations

### Component Structure
- `user/` - User creation, SSH configuration, deploy user setup
- `web/` - Caddy installation and UFW firewall setup
- `docker/` - Docker installation and network creation
- `monitoring/` - Prometheus stack setup
- `utils/` - System utilities (vim, zsh, make)
- `templates/` - Configuration templates for services

### Docker Networks
The system creates two external networks:
- `caddy_net` - For web services
- `monitoring_net` - For monitoring stack

### Templates Directory
- `templates/caddy/full/` - Complete Caddy setup with WAF, CrowdSec, and authentication
- `templates/monitoring/` - Prometheus, Loki, Grafana, Node Exporter, cAdvisor stack
- `templates/nginx-certbot/` - Alternative nginx setup

### Key Files
- `templates/caddy/full/docker-compose.yml` - Main Caddy service definition
- `templates/monitoring/docker-compose.yml` - Monitoring stack services
- `web/install_caddy.sh:33` - Caddy installation with password setup
- `monitoring/install_prometheus.sh:25` - Monitoring stack deployment

## Installation Flow

1. Server update and package installation
2. Docker installation and network creation
3. Caddy installation with security features
4. User and SSH configuration
5. Monitoring stack deployment
6. System utilities installation

The installer prompts for Prometheus and Loki passwords during setup, which are encrypted using Caddy's hash-password function.

## Custom Caddy Image

The project builds a custom Caddy image (`ghcr.io/elagala/server-initializer/caddy-waf-crowdsec:latest`) that includes:
- Coraza WAF module
- CrowdSec bouncer integration
- Basic authentication support
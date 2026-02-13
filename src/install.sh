#!/bin/bash

source ./user/create_user.sh
source ./user/create_deploy_user.sh
source ./user/ssh_config.sh
source ./web/install_caddy.sh
source ./web/setup_ufw.sh
source ./docker/install_docker.sh
source ./docker/create_networks.sh
source ./utils/install_vim.sh
source ./utils/install_zsh.sh
source ./utils/install_make.sh
source ./monitoring/install_prometheus.sh

chmod +x ./user/create_user.sh
chmod +x ./user/ssh_config.sh
chmod +x ./web/setup_ufw.sh
chmod +x ./docker/install_docker.sh
chmod +x ./utils/install_vim.sh
chmod +x ./utils/install_zsh.sh
chmod +x ./monitoring/install_prometheus.sh

if [ -z "$1" ]; then
  echo "Usage: $0 <username> [--development]"
  exit 1
fi

# Check for development flag
DEVELOPMENT_MODE=false
if [ "$2" = "--development" ]; then
  DEVELOPMENT_MODE=true
fi

# Get the repository directory (parent of src/)
REPO_DIR="$(dirname "$PWD")"

# Log file for verbose output
LOG_FILE="/var/log/server-initializer.log"
> "$LOG_FILE"

run_step() {
  local label="$1"
  shift
  printf "  %-40s" "$label"
  if "$@" >> "$LOG_FILE" 2>&1; then
    echo "done"
  else
    echo "FAILED (see $LOG_FILE)"
    exit 1
  fi
}

echo ""
echo "============================================"
echo "       SERVER INITIALIZATION"
echo "============================================"
echo ""

if [ "$DEVELOPMENT_MODE" = "true" ]; then
  echo "  Mode: development (Docker ops skipped)"
  echo ""
fi

# Update server packages
run_step "Updating server packages..." bash -c 'sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y'

# User
run_step "Creating admin user..." create_user "$1"
run_step "Configuring SSH for $1..." config_ssh "$1"

# Deploy user
run_step "Creating deploy user..." create_deploy_user
run_step "Configuring SSH for deploy..." config_ssh "deploy"

# Docker
run_step "Installing Docker..." install_docker
run_step "Creating Docker networks..." create_networks

# Add users to docker group
run_step "Adding users to Docker group..." bash -c "sudo usermod -aG docker $1 && sudo usermod -aG docker deploy"

# Web
run_step "Installing Caddy..." install_caddy "$1" "$REPO_DIR" "$DEVELOPMENT_MODE"
run_step "Setting up UFW..." setup_ufw

# Utils
run_step "Installing Vim..." install_vim
run_step "Installing Zsh..." install_zsh "$1"
run_step "Installing Make..." install_make

# Monitoring
run_step "Installing monitoring stack..." install_prometheus "$1" "$REPO_DIR" "$DEVELOPMENT_MODE"

echo ""
echo "============================================"
echo "           INSTALLATION SUMMARY"
echo "============================================"
echo ""
echo "USERS"
echo "  Admin:  $1 / $ADMIN_USER_PASSWORD"
echo "  Deploy: deploy / $DEPLOY_USER_PASSWORD"
echo ""
echo "WEB SERVER (Caddy)"
echo "  Dir:    /home/$1/web-server"
echo "  Sites:  /home/$1/web-server/caddy/sites-enabled/"
echo ""
echo "MONITORING"
echo "  Dir:              /home/$1/monitoring"
echo "  Prometheus pass:  $prometheus_plain_password"
echo "  Loki pass:        $loki_plain_password"
echo ""
echo "CROWDSEC"
echo "  API Key: $CROWDSEC_API_KEY"
echo ""
echo "============================================"

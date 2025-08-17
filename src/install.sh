#!/bin/bash

echo "[ INSTALL ]: Updating server packages"
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y
echo "[ INSTALL ]: Server updated. Starting component installation"

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
  echo "[ INSTALL ]: Running in development mode - Docker operations will be skipped"
fi

# Get the repository directory (parent of src/)
REPO_DIR="$(dirname "$PWD")"

# User
create_user $1
config_ssh $1

# Deploy user
create_deploy_user
config_ssh "deploy"

# Docker
install_docker
create_networks

# Web
install_caddy $1 "$REPO_DIR" "$DEVELOPMENT_MODE"
setup_ufw

# Utils
install_vim
install_zsh $1
install_make

# Monitoring
install_prometheus $1 "$REPO_DIR" "$DEVELOPMENT_MODE"

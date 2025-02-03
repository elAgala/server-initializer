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
  echo "Usage: $0 <username>"
  exit 1
fi

# Docker
install_docker
create_networks

# Web
install_caddy $1
setup_ufw

# User
create_user $1
config_ssh $1

# Deploy user
create_deploy_user
config_ssh "deploy"

# Utils
install_vim
install_zsh $1
install_make

# Monitoring
install_prometheus $1

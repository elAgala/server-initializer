#!/bin/bash

function install_docker() {
  echo "[ DOCKER ]: Started Docker setup"

  echo "[ DOCKER ]: Installing prerequisites"
  # Install prerequisites
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl

  # Create directory for GPG key
  sudo mkdir -p /etc/apt/keyrings

  # Download and install Docker GPG key
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add Docker repository to sources.list
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

  # Update package lists
  sudo apt-get update

  # Install Docker Engine, CLI, containerd, Buildx plugin, and Compose plugin
  if ! dpkg -l | grep -q docker-ce; then
    echo "[ DOCKER ]: Installing Docker"
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo "[ DOCKER ]: Installed succesfully"
  else
    echo "[ DOCKER ]: Docker was already installed"
  fi
}

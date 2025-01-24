#!/bin/bash

function install_prometehus() {
  REPO_URL="https://raw.githubusercontent.com/elAgala/monitoring-template/main"
  username="$1"
  monitoring_dir="/home/$username/monitoring"

  echo "[ MONITOR ]: Starting Prometehus setup"
  mkdir -p "$monitoring_dir"
  wget "$REPO_URL/docker-compose.yml" -O "$monitoring_dir/docker-compose.yml"
  wget "$REPO_URL/prometheus.yml" -O "$monitoring_dir/prometheus.yml"
  cd "$monitoring_dir"
  echo "[ MONITOR ]: Prometheus Installed. Starting on docker container"
  sudo docker-compose up -d
  echo "[ MONITOR ]: Prometehus up & running on port 9090"
}

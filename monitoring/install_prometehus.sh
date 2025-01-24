#!/bin/bash

function install_prometehus() {
  REPO_URL = "https://raw.githubusercontent.com/elAgala/monitoring-template/main"
  username="$1"
  monitoring_dir="/home/$username/monitoring"

  echo "[ MONITOR ]: Starting Prometehus setup"
  mkdir -p "$monitoring_dir"
  curl -L "$REPO_URL/docker-compose.yml" -o "$monitoring_dir/docker-compose.yml"
  curl -L "$REPO_URL/prometheus.yml" -o "$monitoring_dir/prometheus.yml"
  cd "$monitoring_dir"
  echo "[ MONITOR ]: Prometheus Installed. Starting on docker container"
  sudo docker-compose up -d
  echo "[ MONITOR ]: Prometehus up & running on port 9090"
}

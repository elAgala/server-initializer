#!/bin/bash

function install_prometheus() {
  REPO_URL="https://raw.githubusercontent.com/elAgala/server-initializer/master"
  TEMPLATE_PATH="/templates/monitoring"
  username="$1"
  monitoring_dir="/home/$username/monitoring"

  echo "[ MONITOR ]: Starting Prometheus setup"
  mkdir -p "$monitoring_dir"
  wget "$REPO_URL/$TEMPLATE_PATH/docker-compose.yml" -O "$monitoring_dir/docker-compose.yml"
  wget "$REPO_URL/$TEMPLATE_PATH/prometheus.yml" -O "$monitoring_dir/prometheus.yml"
  cd "$monitoring_dir"
  echo "[ MONITOR ]: Prometheus Installed. Starting on docker container"
  sudo docker compose up -d
  echo "[ MONITOR ]: Prometheus up & running on port 9090"
}

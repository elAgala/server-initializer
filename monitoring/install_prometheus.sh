#!/bin/bash

function install_prometheus() {
  REPO_URL="https://raw.githubusercontent.com/elAgala/server-initializer/master"
  TEMPLATE_PATH="/templates/monitoring"
  username="$1"
  monitoring_dir="/home/$username/monitoring"

  echo "[ MONITOR ]: Starting monitoring setup"
  mkdir -p "$monitoring_dir"
  mkdir -p "$monitoring_dir/loki"
  mkdir -p "$monitoring_dir/promtail"
  mkdir -p "$monitoring_dir/alerts"
  
  # Download main monitoring files
  wget "$REPO_URL/$TEMPLATE_PATH/docker-compose.yml" -O "$monitoring_dir/docker-compose.yml"
  wget "$REPO_URL/$TEMPLATE_PATH/prometheus.yml" -O "$monitoring_dir/prometheus.yml"
  
  # Download Loki configuration
  wget "$REPO_URL/$TEMPLATE_PATH/loki/loki.yml" -O "$monitoring_dir/loki/loki.yml"
  
  # Download Promtail configuration
  wget "$REPO_URL/$TEMPLATE_PATH/promtail/promtail.yml" -O "$monitoring_dir/promtail/promtail.yml"
  
  # Download alert rules
  wget "$REPO_URL/$TEMPLATE_PATH/alerts/infrastructure.yml" -O "$monitoring_dir/alerts/infrastructure.yml"
  wget "$REPO_URL/$TEMPLATE_PATH/alerts/web-server.yml" -O "$monitoring_dir/alerts/web-server.yml"
  wget "$REPO_URL/$TEMPLATE_PATH/alerts/docker.yml" -O "$monitoring_dir/alerts/docker.yml"
  
  cd "$monitoring_dir"
  echo "[ MONITOR ]: Monitoring stack installed. Starting containers"
  sudo docker compose up -d
  echo "[ MONITOR ]: Monitoring stack running:"
  echo "  - Prometheus: http://localhost:9090 (internal)"
  echo "  - Prometheus API: https://YOUR_SERVER_IP/prometheus/ (external)"
  echo "  - Loki: http://localhost:3100 (internal)"
  echo "  - Node Exporter: http://localhost:9100 (internal)"
  echo "  - cAdvisor: http://localhost:8080 (internal)"
}

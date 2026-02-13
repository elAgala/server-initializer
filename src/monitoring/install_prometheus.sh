#!/bin/bash

function install_prometheus() {
  username="$1"
  repo_dir="$2"
  development_mode="$3"
  template_path="$repo_dir/templates/monitoring"
  monitoring_dir="/home/$username/monitoring"

  echo "[ MONITOR ]: Starting monitoring setup"
  mkdir -p "$monitoring_dir"
  mkdir -p "$monitoring_dir/loki"
  mkdir -p "$monitoring_dir/promtail"
  
  # Copy main monitoring files from local repo
  cp "$template_path/docker-compose.yml" "$monitoring_dir/docker-compose.yml"
  cp "$template_path/prometheus.yml" "$monitoring_dir/prometheus.yml"
  
  # Copy Loki configuration
  cp "$template_path/loki/loki.yml" "$monitoring_dir/loki/loki.yml"
  
  # Copy Promtail configuration
  cp "$template_path/promtail/promtail.yml" "$monitoring_dir/promtail/promtail.yml"
  
  cd "$monitoring_dir" || return 1
  if [ "$development_mode" = "true" ]; then
    echo "[ MONITOR ]: Development mode - skipping Docker operations"
    echo "[ MONITOR ]: Monitoring stack files copied successfully"
  else
    echo "[ MONITOR ]: Monitoring stack installed. Starting containers"
    sudo docker compose up -d
    echo "[ MONITOR ]: Monitoring stack running:"
    echo "  - Prometheus: http://localhost:9090 (internal)"
    echo "  - Prometheus API: https://YOUR_SERVER_IP/prometheus/ (external)"
    echo "  - Loki: http://localhost:3100 (internal)"
    echo "  - Node Exporter: http://localhost:9100 (internal)"
    echo "  - cAdvisor: http://localhost:8080 (internal)"
  fi
}

#!/bin/bash

function install_caddy() {

  username="$1"
  repo_dir="$2"
  development_mode="$3"
  template_path="$repo_dir/templates/caddy/full"
  caddy_dir="/home/$username/web-server"

  echo "[ WEB ]: Starting Caddy setup"
  mkdir -p "$caddy_dir"
  mkdir -p "$caddy_dir/crowdsec"
  mkdir -p "$caddy_dir/caddy"
  mkdir -p "$caddy_dir/caddy/coraza"
  mkdir -p "$caddy_dir/caddy/sites-enabled"

  sudo chown -R "$username:$username" "$caddy_dir"

  # Copy configuration files from local repo
  cp "$template_path/docker-compose.yml" "$caddy_dir/docker-compose.yml"
  cp "$template_path/Makefile" "$caddy_dir/Makefile"
  cp "$template_path/caddy/Caddyfile" "$caddy_dir/caddy/Caddyfile"
  cp "$template_path/caddy/coraza/coraza.conf" "$caddy_dir/caddy/coraza/coraza.conf"
  cp "$template_path/crowdsec/acquis.yaml" "$caddy_dir/crowdsec/acquis.yaml"
  cp "$template_path/caddy/sites-enabled/prometheus.Caddyfile" "$caddy_dir/caddy/sites-enabled/prometheus.Caddyfile"
  cp "$template_path/caddy/sites-enabled/loki.Caddyfile" "$caddy_dir/caddy/sites-enabled/loki.Caddyfile"
  cp "$template_path/caddy/sites-enabled/examples.Caddyfile" "$caddy_dir/caddy/sites-enabled/examples.Caddyfile"

  if [ "$development_mode" = "true" ]; then
    echo "[ WEB ]: Development mode - skipping Docker operations"
    echo "[ WEB ]: Creating placeholder .env file..."
    cd "$caddy_dir" || return 1
    cat >"$caddy_dir/.env" <<EOF
CROWDSEC_API_KEY=dev-placeholder-key
PROMETHEUS_PASSWORD=dev-placeholder-password
LOKI_PASSWORD=dev-placeholder-password
EOF
  else
    echo "[ WEB ]: Installing apache2-utils for password hashing..."
    sudo apt-get update
    sudo apt-get install -y apache2-utils

    echo "[ WEB ]: Setting up authentication passwords..."
    prometheus_plain_password="${MONITORING_PROMETHEUS_PASSWORD:-$(openssl rand -base64 16)}"
    loki_plain_password="${MONITORING_LOKI_PASSWORD:-$(openssl rand -base64 16)}"

    # Generate password hashes using htpasswd (no Caddy needed)
    echo "[ WEB ]: Hashing Prometheus password..."
    PROMETHEUS_PASSWORD=$(htpasswd -nbB user "$prometheus_plain_password" | cut -d: -f2)
    echo "[ WEB ]: Hashing Loki password..."
    LOKI_PASSWORD=$(htpasswd -nbB user "$loki_plain_password" | cut -d: -f2)

    cd "$caddy_dir" || return 1

    # Start only CrowdSec first
    echo "[ WEB ]: Starting CrowdSec container..."
    sudo docker compose up -d crowdsec

    # Wait for CrowdSec to be ready with health check
    echo "[ WEB ]: Waiting for CrowdSec to be ready..."
    for i in {1..30}; do
      if sudo docker exec crowdsec cscli version >/dev/null 2>&1; then
        echo "[ WEB ]: CrowdSec is ready!"
        break
      fi
      echo "[ WEB ]: Waiting for CrowdSec... ($i/30)"
      sleep 2
    done

    # Check if CrowdSec is ready
    if ! sudo docker exec crowdsec cscli version >/dev/null 2>&1; then
      echo "[ WEB ]: ERROR: CrowdSec failed to start properly. Check logs with: docker compose logs crowdsec"
      return 1
    fi

    # Generate CrowdSec API key
    echo "[ WEB ]: Generating CrowdSec API key..."
    CROWDSEC_API_KEY=$(sudo docker exec crowdsec cscli bouncers add caddy-bouncer -o raw)

    # Create final .env file with all real values
    cat >"$caddy_dir/.env" <<EOF
CROWDSEC_API_KEY='$CROWDSEC_API_KEY'
PROMETHEUS_PASSWORD='$PROMETHEUS_PASSWORD'
LOKI_PASSWORD='$LOKI_PASSWORD'
EOF

    # Start all containers now that passwords are ready
    echo "[ WEB ]: Starting all containers with generated keys..."
    sudo docker compose up -d

  fi

  echo "[ WEB ]: Caddy setup completed successfully!"
  echo "[ WEB ]: Configuration location: $caddy_dir"
  echo "[ WEB ]: Add your site configurations to: $caddy_dir/caddy/sites-enabled/"
}

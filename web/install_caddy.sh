#!/bin/bash

function install_caddy() {

  REPO_URL="https://raw.githubusercontent.com/elAgala/server-initializer/master"
  TEMPLATE_PATH="templates/caddy/full"

  username="$1"
  caddy_dir="/home/$username/web-server"

  echo "[ WEB ]: Starting Caddy setup"
  mkdir -p "$caddy_dir"
  mkdir -p "$caddy_dir/crowdsec"
  mkdir -p "$caddy_dir/caddy"
  mkdir -p "$caddy_dir/caddy/coraza"
  mkdir -p "$caddy_dir/caddy/sites-enabled"

  chown -R "$username:$username" "$caddy_dir"

  # Download configuration files
  wget "$REPO_URL/$TEMPLATE_PATH/docker-compose.yml" -O "$caddy_dir/docker-compose.yml"
  wget "$REPO_URL/$TEMPLATE_PATH/Makefile" -O "$caddy_dir/Makefile"
  wget "$REPO_URL/$TEMPLATE_PATH/caddy/Caddyfile" -O "$caddy_dir/caddy/Caddyfile"
  wget "$REPO_URL/$TEMPLATE_PATH/caddy/coraza/coraza.conf" -O "$caddy_dir/caddy/coraza/coraza.conf"
  wget "$REPO_URL/$TEMPLATE_PATH/crowdsec/acquis.yaml" -O "$caddy_dir/crowdsec/acquis.yaml"
  wget "$REPO_URL/$TEMPLATE_PATH/caddy/sites-enabled/prometheus.Caddyfile" -O "$caddy_dir/caddy/sites-enabled/prometheus.Caddyfile"
  wget "$REPO_URL/$TEMPLATE_PATH/caddy/sites-enabled/examples.Caddyfile" -O "$caddy_dir/caddy/sites-enabled/examples.Caddyfile"

  echo "[ WEB ]: Starting containers to generate keys..."
  cd "$caddy_dir"
  
  # Prompt user for passwords and encrypt them using Caddy
  echo "[ WEB ]: Setting up authentication passwords..."
  echo -n "Enter password for Prometheus access: "
  read -s prometheus_plain_password
  echo
  echo -n "Enter password for Loki access: "
  read -s loki_plain_password
  echo
  
  # Create .env file with placeholder
  cat > "$caddy_dir/.env" <<EOF
CROWDSEC_API_KEY=PLACEHOLDER_WILL_BE_REPLACED
PROMETHEUS_PASSWORD=PLACEHOLDER_WILL_BE_REPLACED
LOKI_PASSWORD=PLACEHOLDER_WILL_BE_REPLACED
EOF
  
  # Start containers
  sudo docker compose up -d
  
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
  
  # Encrypt passwords using Caddy
  echo "[ WEB ]: Encrypting Prometheus password..."
  PROMETHEUS_PASSWORD=$(sudo docker exec caddy caddy hash-password --plaintext "$prometheus_plain_password")
  echo "[ WEB ]: Encrypting Loki password..."
  LOKI_PASSWORD=$(sudo docker exec caddy caddy hash-password --plaintext "$loki_plain_password")
  
  # Update .env file with real API key and encrypted passwords
  cat > "$caddy_dir/.env" <<EOF
CROWDSEC_API_KEY=$CROWDSEC_API_KEY
PROMETHEUS_PASSWORD=$PROMETHEUS_PASSWORD
LOKI_PASSWORD=$LOKI_PASSWORD
EOF
  
  # Restart containers with new API key
  echo "[ WEB ]: Restarting containers with generated keys..."
  sudo docker compose down
  sudo docker compose up -d
  
  echo "[ WEB ]: Caddy setup completed successfully!"
  echo "[ WEB ]: Configuration location: $caddy_dir"
  echo "[ WEB ]: CrowdSec API key: $CROWDSEC_API_KEY"
  echo "[ WEB ]: Prometheus password: [ENCRYPTED AND STORED IN .env]"
  echo "[ WEB ]: Loki password: [ENCRYPTED AND STORED IN .env]"
  echo "[ WEB ]: Add your site configurations to: $caddy_dir/caddy/sites-enabled/"
}

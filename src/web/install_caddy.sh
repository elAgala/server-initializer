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
  sudo chown -R "$username:$username" "$caddy_dir"

  # Create the real sites-enabled directory under deploy's home
  sudo mkdir -p /home/deploy/caddy-sites
  sudo chown deploy:deploy /home/deploy/caddy-sites
  sudo chmod 2775 /home/deploy/caddy-sites

  # Copy configuration files from local repo
  cp "$template_path/docker-compose.yml" "$caddy_dir/docker-compose.yml"
  cp "$template_path/Makefile" "$caddy_dir/Makefile"
  cp "$template_path/caddy/Caddyfile" "$caddy_dir/caddy/Caddyfile"
  cp "$template_path/caddy/coraza/coraza.conf" "$caddy_dir/caddy/coraza/coraza.conf"
  cp "$template_path/crowdsec/acquis.yaml" "$caddy_dir/crowdsec/acquis.yaml"

  # Copy initial site configs to deploy-owned directory
  cp "$template_path/caddy/sites-enabled/examples.Caddyfile" /home/deploy/caddy-sites/
  sudo chown deploy:deploy /home/deploy/caddy-sites/*

  # Symlink from caddy dir to deploy-owned directory
  ln -s /home/deploy/caddy-sites "$caddy_dir/caddy/sites-enabled"

  if [ "$development_mode" = "true" ]; then
    echo "[ WEB ]: Development mode - skipping Docker operations"
    echo "[ WEB ]: Creating placeholder .env file..."
    cd "$caddy_dir" || return 1
    cat >"$caddy_dir/.env" <<EOF
CROWDSEC_API_KEY=dev-placeholder-key
EOF
  else
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
EOF

    # Start all containers now that passwords are ready
    echo "[ WEB ]: Starting all containers with generated keys..."
    sudo docker compose up -d

  fi

  echo "[ WEB ]: Caddy setup completed successfully!"
  echo "[ WEB ]: Configuration location: $caddy_dir"
  echo "[ WEB ]: Add your site configurations to: $caddy_dir/caddy/sites-enabled/"
}

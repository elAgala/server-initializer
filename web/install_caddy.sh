#!/bin/bash

function install_caddy() {

  REPO_URL="https://raw.githubusercontent.com/elAgala/server-initializer/master"
  TEMPLATE_PATH="/templates/caddy"
  username="$1"
  caddy_dir="/home/$username/caddy"

  echo "[ WEB ]: Starting Caddy setup"
  mkdir -p "$caddy_dir"
  mkdir -p "$caddy_dir/settings"
  wget "$REPO_URL/$TEMPLATE_PATH/docker-compose.yml" -O "$caddy_dir/docker-compose.yml"
  wget "$REPO_URL/$TEMPLATE_PATH/Caddyfile" -O "$caddy_dir/settings/Caddyfile"
  echo "[ WEB ]: Caddy setup succesfully. You can find the Caddyfile under /home/$username/caddy/settings"
}

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

  chown -R "$username:$username" "$caddy_dir"

  wget "$REPO_URL/$TEMPLATE_PATH/docker-compose.yml" -O "$caddy_dir/docker-compose.yml"
  wget "$REPO_URL/$TEMPLATE_PATH/.env" -O "$caddy_dir/.env"
  wget "$REPO_URL/$TEMPLATE_PATH/caddy/Caddyfile" -O "$caddy_dir/caddy/Caddyfile"
  wget "$REPO_URL/$TEMPLATE_PATH/caddy/coraza/coraza.conf" -O "$caddy_dir/caddy/coraza/coraza.conf"
  wget "$REPO_URL/$TEMPLATE_PATH/crowdsec/acquis.yaml" -O "$caddy_dir/crowdsec/acquis.yaml"

  echo "[ WEB ]: Caddy setup succesfully. You can find the Caddyfile under /home/$username/web_server/caddy"
  echo "[ WEB ]: Do not forget to update the .env file located under $caddy_dir"
  docker network create caddy_net
  echo "[ WEB ]: Created caddy intranet 'caddy_net'"
}

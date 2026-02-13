#!/bin/bash

function create_networks() {
  docker network ls --format '{{.Name}}' | grep -q '^caddy_net$' \
    || docker network create caddy_net
  echo "[ DOCKER ]: Created caddy intranet 'caddy_net'"
  docker network ls --format '{{.Name}}' | grep -q '^monitoring_net$' \
    || docker network create monitoring_net
  echo "[ DOCKER ]: Created monitoring intranet 'monitoring_net'"
}

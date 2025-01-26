#!/bin/bash

function create_networks() {
  docker network create caddy_net
  echo "[ DOCKER ]: Created caddy intranet 'caddy_net'"
  docker network create monitoring_net
  echo "[ DOCKER ]: Created monitoring intranet 'monitoring_net'"
}

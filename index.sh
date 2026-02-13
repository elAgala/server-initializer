#!/bin/bash

REPO_URL="https://github.com/elAgala/server-initializer"
TARGET_DIR="/tmp/server-initializer"

ADMIN_USER="${1:-${ADMIN_USER:-}}"
if [ -z "$ADMIN_USER" ]; then
  echo "[ ERROR ]: No username provided. Pass as argument or set ADMIN_USER env var"
  exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo "Cloning the repository..."
  git clone "$REPO_URL" "$TARGET_DIR"
fi

cd "$TARGET_DIR/src" || exit 1

echo "[ INITIALIZER ]: Starting initialization"

chmod +x ./install.sh
./install.sh "$ADMIN_USER"

echo "[ INITIALIZER ]: Setup completed succesfully!"

echo "[ INITIALIZER ]: Cleaning up"
cd /
rm -rf "$TARGET_DIR"
echo "[ INITIALIZER ]: Success!"

#!/bin/bash

REPO_URL="https://github.com/elAgala/server-initializer"
TARGET_DIR="/tmp/server-initializer"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Cloning the repository..."
  git clone "$REPO_URL" "$TARGET_DIR"
fi

cd "$TARGET_DIR" || exit 1

echo "Running install.sh from the cloned repository..."
chmod +x ./install.sh
./install.sh "$1"

echo "Cleaning up..."
cd /
rm -rf "$TARGET_DIR"
echo "Cleanup complete!"

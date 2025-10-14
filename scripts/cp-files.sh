#!/usr/bin/bash

PARENT_DIR="$(realpath "$(dirname "$0")/..")"
sudo mkdir -p /usr/share/hypr
sudo cp "$(PARENT_DIR)/images/bg.png" /usr/share/hypr/bg.png

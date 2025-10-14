#!/usr/bin/bash

PARENT_DIR="$(realpath "$(dirname "$0")/..")"
sudo mkdir -p $HOME/.config/system/background
sudo cp "$(PARENT_DIR)/images/bg.png" /$HOME/.config/system/background/bg.png

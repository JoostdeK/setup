#!/bin/bash
# Clone the setup repository into dev/setup

# Exit on error
set -e

git config --global user.email "joost.dekat@hotmail.com"
git config --global user.name "JoostdeK"

# Define target directory
TARGET_DIR="$HOME/dev/setup"

# Create parent directory if it doesn't exist
mkdir -p "$(dirname "$TARGET_DIR")"

# If the directory already exists, warn or update
if [ -d "$TARGET_DIR/.git" ]; then
  echo "Repository already exists at $TARGET_DIR. Pulling latest changes..."
  git -C "$TARGET_DIR" pull
else
  echo "Cloning repository into $TARGET_DIR..."
  git clone https://github.com/JoostdeK/setup.git "$TARGET_DIR"
fi

echo "Done. Repository available at: $TARGET_DIR"

# Clone the setup repository into dev/omarchy

# Exit on error
set -e

# Define target directory
TARGET_DIR="$HOME/dev/omarchy"

# Create parent directory if it doesn't exist
mkdir -p "$(dirname "$TARGET_DIR")"

# If the directory already exists, warn or update
if [ -d "$TARGET_DIR/.git" ]; then
  echo "Repository already exists at $TARGET_DIR. Pulling latest changes..."
  git -C "$TARGET_DIR" pull
else
  echo "Cloning repository into $TARGET_DIR..."
  git clone "https://github.com/basecamp/omarchy $TARGET_DIR"
fi

echo "Done. Repository available at: $TARGET_DIR"

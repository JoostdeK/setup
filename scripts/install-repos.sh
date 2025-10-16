#!/bin/bash
# Clone the setup and omarchy repositories into dev/

# Exit on error
set -e

# Prompt for Git configuration
read -p "Enter your Git user name: " GIT_USERNAME
read -p "Enter your Git email: " GIT_EMAIL

# Configure Git globally
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

echo "Git configured with:"
echo "  Name:  $GIT_USERNAME"
echo "  Email: $GIT_EMAIL"
echo

# ---- Clone omarchy repository ----
TARGET_DIR="$HOME/dev/omarchy"

mkdir -p "$(dirname "$TARGET_DIR")"

if [ -d "$TARGET_DIR/.git" ]; then
  echo "Repository already exists at $TARGET_DIR. Pulling latest changes..."
  git -C "$TARGET_DIR" pull
else
  echo "Cloning repository into $TARGET_DIR..."
  git clone https://github.com/basecamp/omarchy.git "$TARGET_DIR"
fi

echo "Done. Repository available at: $TARGET_DIR"

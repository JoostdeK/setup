#!/bin/bash
# This is the master run file
# other files will be called from here

set -euo pipefail

# Get the directory this script is in
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# Install all required packages from list
"$SCRIPT_DIR/scripts/install-packages.sh"
"$SCRIPT_DIR/scripts/install-config.sh"
"$SCRIPT_DIR/scripts/install-repos.sh"
"$SCRIPT_DIR/scripts/install-gaming.sh"
sudo "$SCRIPT_DIR/scripts/configure-startup.sh" jvdb
"$SCRIPT_DIR/scripts/finish.sh"

##   install catpucchin theme in kitty.

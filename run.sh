#!/bin/bash
# This is the master run file
# other files will be called from here

set -euo pipefail

# Get the directory this script is in
SCRIPT_DIR="$(dirname -- "${BASH_SOURCE[0]}")/packages" >/dev/null 2>&1 && pwd

# Install all required packages from list
"$SCRIPT_DIR/install-packages.sh"

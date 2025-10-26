#!/bin/bash

set -euo pipefail

read -p "Do you want to install cura dependencies? (Yy/Nn) " ANSWER

case "$ANSWER" in
[Yy] | [Yy][Ee][Ss])
  echo "You chose yes."
  sudo pacman -Sy --noconfirm fuse2
  ;;
[Nn] | [Nn][Oo])
  echo "You chose no."
  exit 0
  ;;
*)
  echo "Invalid input. Please enter y or n."
  exit 1
  ;;
esac

DEST_DIR="${HOME}/apps"
mkdir -p "$DEST_DIR"

REPO="Ultimaker/Cura"
API_URL="https://api.github.com/repos/${REPO}/releases?per_page=10"

echo "Locating latest Cura AppImage..."

# Try GitHub API first: prefer x86_64/amd64 AppImage, fallback to any AppImage
URL="$(curl -fsSL "$API_URL" |
  grep -oP '"browser_download_url":\s*"\K[^"]+\.AppImage(?=")' |
  awk '
      BEGIN{IGNORECASE=1}
      /x86_64|amd64/ {print; found=1; exit}
      { candidates[++n]=$0 }
      END{ if(!found && n>0) print candidates[1] }
    ' || true)"

# If API is rate-limited or empty, fall back to scraping the latest release HTML
if [[ -z "${URL}" ]]; then
  HTML="$(curl -fsSL "https://github.com/${REPO}/releases/latest")" || HTML=""
  # prefer x86_64/amd64
  REL_PATH="$(printf "%s" "$HTML" |
    grep -oE 'href="[^"]+\.AppImage"' |
    sed -E 's/^href="(.*)"/\1/' |
    awk '
        BEGIN{IGNORECASE=1}
        /x86_64|amd64/ {print; found=1; exit}
        { candidates[++n]=$0 }
        END{ if(!found && n>0) print candidates[1] }
      ' || true)"
  if [[ -n "${REL_PATH}" ]]; then
    # Ensure absolute URL
    if [[ "${REL_PATH}" != https://* ]]; then
      URL="https://github.com${REL_PATH}"
    else
      URL="${REL_PATH}"
    fi
  fi
fi

if [[ -z "${URL}" ]]; then
  echo "Could not find a Cura AppImage URL. GitHub may be rate-limiting or no assets are present."
  exit 1
fi

FILENAME="cura.AppImage"
OUTFILE="${DEST_DIR}/${FILENAME}"

if [[ -f "$OUTFILE" ]]; then
  echo "Already have ${OUTFILE}"
else
  echo "Downloading ${FILENAME} ..."
  curl -fL --progress-bar "$URL" -o "$OUTFILE"
  chmod +x "$OUTFILE"
  echo "Saved to ${OUTFILE}"
fi

echo "Done."

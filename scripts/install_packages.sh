#!/usr/bin/env bash

# makes the script strict and safe:
#-e: exit immediately if a command fails (no half-broken runs)
#-u: exit if you reference an undefined variable
#-o pipefail: makes pipelines fail if any part fails (not just the last command)
set -euo pipefail

# Path to the list file (packages/list relative to this script)
# Figures out where the script itself lives (${BASH_SOURCE[0]}).
#Moves one directory up (../packages).
#Builds the full absolute path to the list file.
#So even if you run the script from another directory, it still finds packages/list.
LIST_FILE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)/../packages/list"

if [[ ! -f "$LIST_FILE" ]]; then
  echo "Package list not found: $LIST_FILE" >&2
  exit 1
fi

# Minimal noise + noninteractive pacman
PACMAN="sudo pacman --noconfirm --needed -S"
YAY_OPTS=(--noconfirm --needed --removemake --answerdiff N --answerclean N)

ensure_yay() {
  if command -v yay >/dev/null 2>&1; then return; fi

  # Try repo first (some distros/package sets provide yay in community/extra)
  if pacman -Si yay >/dev/null 2>&1; then
    sudo pacman --noconfirm --needed -S yay
    return
  fi

  # Build from AUR (uses yay-bin for speed)
  sudo pacman --noconfirm --needed -S base-devel git
  tmpdir="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
  (cd "$tmpdir/yay-bin" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
}

install_repo_pkg() {
  local pkg="$1"
  # If pacman knows it, install with pacman
  if pacman -Si -- "$pkg" >/dev/null 2>&1; then
    $PACMAN -- "$pkg"
    return 0
  fi
  return 1
}

install_aur_pkg() {
  local pkg="$1"
  ensure_yay
  yay -S "${YAY_OPTS[@]}" -- "$pkg"
}

main() {
  # Refresh sync db once
  sudo pacman -Sy --noconfirm

  # Read list, ignore blank lines and comments
  while IFS= read -r raw || [[ -n "$raw" ]]; do
    pkg="$(sed -e 's/#.*$//' <<<"$raw" | xargs || true)"
    [[ -z "$pkg" ]] && continue

    # Already installed? skip fast
    if pacman -Qq -- "$pkg" >/dev/null 2>&1; then
      echo "✔ $pkg (already installed)"
      continue
    fi

    # Try repo; fallback to AUR
    if install_repo_pkg "$pkg"; then
      echo "✔ $pkg (repo)"
    else
      echo "… $pkg not in repos, trying AUR"
      install_aur_pkg "$pkg"
      echo "✔ $pkg (AUR)"
    fi
  done <"$LIST_FILE"
}

main "$@"

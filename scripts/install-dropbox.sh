#!/bin/bash

set -euo pipefail

read -p "Do you want to install dropbox? (Yy/Nn) " ANSWER

case "$ANSWER" in
[Yy] | [Yy][Ee][Ss])
  echo "You chose yes."
  yay -Sy --noconfirm dropbox dropbox-cli libappindicator-gtk3 python-gpgme nautilus-dropbox
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

dropbox-cli exclude add ./*

echo "Done."

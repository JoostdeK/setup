#!/bin/bash

set -euo pipefail

read -p "Do you want to install gaming dependencies? (Yy/Nn) " ANSWER

case "$ANSWER" in
[Yy] | [Yy][Ee][Ss])
  echo "You chose yes."
  ;;
[Nn] | [Nn][Oo])
  echo "You chose no."
  exit 0
  ;;
*)
  echo "Invalid input. Please enter y or n."
  ;;
esac

#!/bin/bash
# Enable the multilib repository in /etc/pacman.conf
#!/bin/bash
# Enable the multilib repository in /etc/pacman.conf (only that block)

PACMAN_CONF="/etc/pacman.conf"
BACKUP="/etc/pacman.conf.bak.$(date +%F-%H%M%S)"

echo "Backup -> $BACKUP"
sudo cp "$PACMAN_CONF" "$BACKUP"

# 1) Uncomment the [multilib] header if it's commented
sudo sed -i 's/^[[:space:]]*#[[:space:]]*\[multilib\][[:space:]]*$/[multilib]/' "$PACMAN_CONF"

# 2) Inside the multilib block only (from [multilib] to next [section]),
#    uncomment the Include line for mirrorlist.
sudo sed -i '/^[[:space:]]*\[multilib\][[:space:]]*$/,/^[[:space:]]*\[/{ 
  /^[[:space:]]*#[[:space:]]*Include[[:space:]]*=[[:space:]]*\/etc\/pacman\.d\/mirrorlist/ s/^[[:space:]]*#[[:space:]]*//
}' "$PACMAN_CONF"

sudo pacman -Sy

read -p "Which drivers do you want to install? amd/nvidea " ANSWER

case "$ANSWER" in
[amd] | [Aa][Mm][Dd])
  echo "You chose AMD."
  ;;
[nvidea])
  echo "You chose NVIDEA."
  exit 0
  ;;
*)
  echo "Invalid input. Please enter y or n."
  ;;
esac

sudo pacman -S mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon xf86-video-amdgpu

sudo pacman -S steam

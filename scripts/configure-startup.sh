#!/usr/bin/bash
set -euo pipefail
TARGET_USER="${1:-${SUDO_USER:-${USER}}}"

# Bepaal HOME en shell van de target user
USER_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
USER_SHELL="$(getent passwd "$TARGET_USER" | cut -d: -f7)"

echo "-> Target user: $TARGET_USER"
echo "-> Home:        $USER_HOME"

# 1) systemd override voor getty@tty1 (autologin)
OVR_DIR="/etc/systemd/system/getty@tty1.service.d"
OVR_FILE="$OVR_DIR/override.conf"
mkdir -p "$OVR_DIR"

# Op Arch staat agetty doorgaans in /usr/bin/agetty
AGETTY_BIN="/usr/bin/agetty"
if [[ ! -x "$AGETTY_BIN" ]]; then
  # fallback (sommige guides gebruiken /sbin/agetty)
  if [[ -x "/sbin/agetty" ]]; then
    AGETTY_BIN="/sbin/agetty"
  else
    echo "agetty niet gevonden in /usr/bin of /sbin." >&2
    exit 1
  fi
fi

cat >"$OVR_FILE" <<EOF
[Service]
ExecStart=
ExecStart=-$AGETTY_BIN --autologin $TARGET_USER --noclear %I \$TERM
Type=idle
EOF

echo "-> Geschreven: $OVR_FILE"

# systemd reload + enable getty@tty1
systemctl daemon-reload
systemctl enable getty@tty1.service

echo "-> getty@tty1 enabled. (Herstart of uit/aan om te gebruiken.)"

echo "Klaar. Reboot nu even: na boot logt TTY1 automatisch in als '$TARGET_USER' en start Hyprland direct."

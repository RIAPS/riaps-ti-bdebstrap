#!/usr/bin/env bash
set -e

RIAPSUSER="riaps"
RIAPSPASSWD="riaps"

# Ensure running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Add new user
echo ">>>>> The user does not exist; setting user account up now"
useradd -m -c "RIAPS App Developer" "$RIAPSUSER" -s /bin/bash -d /home/$RIAPSUSER

# Set password for new user
echo "$RIAPSUSER:$RIAPSPASSWD" | chpasswd

getent group gpio || groupadd gpio
getent group dialout || groupadd dialout
usermod -aG sudo $RIAPSUSER
usermod -aG dialout $RIAPSUSER
usermod -aG gpio  $RIAPSUSER

chmod 755 /home/$RIAPSUSER
mkdir -p /home/$RIAPSUSER/riaps_apps
chown $RIAPSUSER:$RIAPSUSER /home/$RIAPSUSER/riaps_apps
mkdir -p /home/$RIAPSUSER/.ssh
chown $RIAPSUSER:$RIAPSUSER /home/$RIAPSUSER/.ssh

echo ">>>>> created $RIAPSUSER account"


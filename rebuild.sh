#!/bin/sh
HOSTNAME=$(hostname)
echo "Rebuilding $HOSTNAME"
sudo nixos-rebuild switch --flake .#$HOSTNAME

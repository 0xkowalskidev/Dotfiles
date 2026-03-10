#!/bin/sh
HOST="${1:-$(hostname)}"

echo "Rebuilding $HOST"

if [ "$HOST" = "$(hostname)" ]; then
  sudo nixos-rebuild switch --flake ".#$HOST"
else
  nixos-rebuild switch --flake ".#$HOST" \
    --target-host "kowalski@$HOST" \
    --sudo
fi

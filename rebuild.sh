#!/bin/sh
if [ $# -eq 0 ]; then
  set -- "$(hostname)"
fi

for HOST in "$@"; do
  echo "Rebuilding $HOST"

  if [ "$HOST" = "$(hostname)" ]; then
    sudo nixos-rebuild switch --flake ".#$HOST"
  else
    nixos-rebuild switch --flake ".#$HOST" \
      --target-host "kowalski@$HOST" \
      --sudo
  fi
done

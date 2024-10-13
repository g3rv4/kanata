#!/bin/bash

while true; do
  if [ -f /tmp/kanata.stdout ]; then
    tail -f /tmp/kanata.stdout
    break
  else
    echo "File not found, retrying in 3 seconds..."
    sleep 3
  fi
done

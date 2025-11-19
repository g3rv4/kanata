#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing kanata configuration..."

# Create the kanata-tray config directory if it doesn't exist
KANATA_TRAY_DIR="$HOME/Library/Application Support/kanata-tray"
if [ ! -d "$KANATA_TRAY_DIR" ]; then
    echo "Creating $KANATA_TRAY_DIR"
    mkdir -p "$KANATA_TRAY_DIR"
fi

# Create symlink for kanata-tray.toml
TRAY_CONFIG_TARGET="$KANATA_TRAY_DIR/kanata-tray.toml"
if [ -L "$TRAY_CONFIG_TARGET" ] || [ -e "$TRAY_CONFIG_TARGET" ]; then
    echo "Removing existing $TRAY_CONFIG_TARGET"
    rm "$TRAY_CONFIG_TARGET"
fi
echo "Creating symlink: $TRAY_CONFIG_TARGET -> $SCRIPT_DIR/kanata-tray.toml"
ln -s "$SCRIPT_DIR/kanata-tray.toml" "$TRAY_CONFIG_TARGET"

# Create the LaunchAgents directory if it doesn't exist
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
if [ ! -d "$LAUNCH_AGENTS_DIR" ]; then
    echo "Creating $LAUNCH_AGENTS_DIR"
    mkdir -p "$LAUNCH_AGENTS_DIR"
fi

# Create symlink for io.gervas.kanata.plist
PLIST_TARGET="$LAUNCH_AGENTS_DIR/io.gervas.kanata.plist"
if [ -L "$PLIST_TARGET" ] || [ -e "$PLIST_TARGET" ]; then
    echo "Removing existing $PLIST_TARGET"
    rm "$PLIST_TARGET"
fi
echo "Creating symlink: $PLIST_TARGET -> $SCRIPT_DIR/io.gervas.kanata.plist"
ln -s "$SCRIPT_DIR/io.gervas.kanata.plist" "$PLIST_TARGET"

# Unload the LaunchAgent if it's already loaded
if launchctl list | grep -q "io.gervas.kanata"; then
    echo "Unloading existing LaunchAgent..."
    launchctl unload "$PLIST_TARGET" 2>/dev/null || true
fi

# Load the LaunchAgent
echo "Loading LaunchAgent..."
launchctl load "$PLIST_TARGET"

echo "Installation complete!"

#!/usr/bin/env bash
set -euo pipefail
INSTALL_DIR="${HOME}/miniforge3"
URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"
TMP="/tmp/miniforge.sh"

if [ -d "$INSTALL_DIR" ]; then
  echo "[INFO] Miniforge already installed at $INSTALL_DIR"
  exit 0
fi

echo "[INFO] Downloading Miniforge installer..."
wget -O "$TMP" "$URL"
chmod +x "$TMP"
echo "[INFO] Installing to $INSTALL_DIR (non-interactive)..."
bash "$TMP" -b -p "$INSTALL_DIR"
rm -f "$TMP"
echo "[INFO] Miniforge installed at $INSTALL_DIR"
echo 'To activate: source "$HOME/miniforge3/etc/profile.d/conda.sh"'

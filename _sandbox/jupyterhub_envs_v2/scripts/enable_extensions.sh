#!/usr/bin/env bash
set -euo pipefail
echo "[INFO] Installing common JupyterLab extensions (pip where appropriate)"
# Use pip inside currently active env; user should activate env first when running
pip install jupyterlab-code-formatter black isort
pip install jupyterlab-collapsible-headings jupyterlab-execute-time
pip install jupyterlab-git jupyterlab-github nbdime
pip install jupyterlab-lsp python-lsp-server[all]
pip install jupyterlab-nvdashboard
pip install "dask[complete]" distributed dask-labextension
pip install jupyterlab-system-monitor
# enable nbdime with git
if command -v nbdime >/dev/null 2>&1; then
  nbdime config-git --enable --global || true
fi
# try to build (may be no-op on modern jlab)
if command -v jupyter >/dev/null 2>&1; then
  jupyter lab build || true
fi
echo "[INFO] Extensions installed (if no errors)."

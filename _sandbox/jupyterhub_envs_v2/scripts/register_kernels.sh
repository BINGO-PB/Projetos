#!/usr/bin/env bash
set -euo pipefail
echo "[INFO] Registering kernels for all envs/*.yml"
for y in envs/*.yml; do
  NAME=$(sed -n 's/^name:[[:space:]]*//p' "$y" | head -n 1 | tr -d '\r' || true)
  if [ -n "$NAME" ]; then
    echo "[INFO] Registering kernel for $NAME"
    source "$HOME/miniforge3/etc/profile.d/conda.sh" || true
    conda activate "$NAME" || true
    python -m ipykernel install --user --name "$NAME" --display-name "$NAME" || true
  fi
done
echo "[INFO] Done."

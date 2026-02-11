#!/usr/bin/env bash
set -euo pipefail
if [ -z "${1:-}" ]; then
  echo "Usage: $0 <env-yml-path-or-name-without-extension>"
  exit 2
fi

INPUT="$1"
# allow either a name (convention) or a path under envs/
if [ -f "$INPUT" ]; then
  YML="$INPUT"
else
  if [ -f "envs/${INPUT}.yml" ]; then
    YML="envs/${INPUT}.yml"
  elif [ -f "envs/${INPUT}.yaml" ]; then
    YML="envs/${INPUT}.yaml"
  else
    echo "Env file not found: $INPUT or envs/${INPUT}.yml"
    exit 3
  fi
fi

# prefer mamba if available for speed
if command -v mamba >/dev/null 2>&1; then
  CONDA_CMD="mamba env create -f \"$YML\" --yes || mamba env update -f \"$YML\" --prune --yes"
else
  CONDA_CMD="conda env create -f \"$YML\" || conda env update -f \"$YML\" --prune"
fi

echo "[INFO] Creating/updating env from $YML ..."
eval "$CONDA_CMD"

# get env name from YAML 'name:' (simple parse)
ENV_NAME=$(sed -n 's/^name:[[:space:]]*//p' "$YML" | head -n 1 | tr -d '\r' || true)
if [ -z "$ENV_NAME" ]; then
  echo "[WARN] Could not determine env name from YAML; skipping kernel registration."
  exit 0
fi

echo "[INFO] Registering Jupyter kernel for $ENV_NAME ..."
source "$HOME/miniforge3/etc/profile.d/conda.sh" || true
conda activate "$ENV_NAME"
python -m ipykernel install --user --name "$ENV_NAME" --display-name "${ENV_NAME}"

echo "[INFO] Environment $ENV_NAME ready."

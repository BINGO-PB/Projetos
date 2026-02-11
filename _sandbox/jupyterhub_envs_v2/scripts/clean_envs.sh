#!/usr/bin/env bash
set -euo pipefail
if [ -z "${1:-}" ]; then
  echo "Usage: $0 <env-name> | --all"
  exit 2
fi
if [ "$1" = "--all" ]; then
  echo "[WARN] Removing all environments defined under envs/ (this will remove conda envs with matching names)."
  for y in envs/*.yml; do
    NAME=$(sed -n 's/^name:[[:space:]]*//p' "$y" | head -n 1 | tr -d '\r' || true)
    if [ -n "$NAME" ]; then
      conda env remove -n "$NAME" --yes || true
    fi
  done
  exit 0
else
  conda env remove -n "$1" --yes
fi

#!/usr/bin/env bash
set -euo pipefail
if [ $# -eq 0 ]; then
  echo "Usage: $0 <path-to-repo> [<path-to-repo> ...]"
  exit 2
fi
for r in "$@"; do
  if [ -d "$r/.git" ]; then
    echo "[INFO] Fetching and pulling $r"
    git -C "$r" fetch --all --prune
    git -C "$r" pull --ff-only || git -C "$r" merge --ff-only || true
  else
    echo "[WARN] $r is not a git repository"
  fi
done

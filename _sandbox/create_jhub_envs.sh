#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${PWD}/jupyterhub_envs_v2"
echo "[INFO] Creating project at $ROOT_DIR"
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

# directories
mkdir -p envs scripts utils docs

# --- env files ---
cat > envs/base-env.yml <<'YAML'
name: base-env
channels:
  - conda-forge
dependencies:
  - python=3.12
  - jupyterlab
  - ipykernel
  - nodejs
  - pip
  - ruff
  - pytest
  - mypy
  - python-lsp-server
  - jupyterlab-git
  - nbconvert
  - psutil
  - pip:
      - jupyterlab-code-formatter
      - black
      - isort
YAML

cat > envs/radioastro-full.yml <<'YAML'
name: radioastro-full
channels:
  - conda-forge
dependencies:
  - python=3.12
  - jupyterlab
  - ipykernel
  - nodejs
  - numpy
  - scipy
  - matplotlib
  - pandas
  - astropy
  - astroquery
  - astropy-healpix
  - healpy
  - reproject
  - mocpy
  - cdshealpix
  - h5py
  - zarr
  - xarray
  - dask
  - distributed
  - numba
  - numexpr
  - cfitsio
  - shapely
  - skyfield
  - wcsaxes
  - pip:
      - plotly
      - holoviews
      - hvplot
      - panel
YAML

cat > envs/radioastro-minimal.yml <<'YAML'
name: radioastro-minimal
channels:
  - conda-forge
dependencies:
  - python=3.12
  - jupyterlab
  - ipykernel
  - numpy
  - scipy
  - matplotlib
  - astropy
  - xarray
  - pip
YAML

cat > envs/cosmology-sim.yml <<'YAML'
name: cosmology-sim
channels:
  - conda-forge
dependencies:
  - python=3.12
  - jupyterlab
  - ipykernel
  - numpy
  - scipy
  - numba
  - emcee
  - camb
  - pip:
      - classy
      - arviz
YAML

cat > envs/tod-processing.yml <<'YAML'
name: tod-processing
channels:
  - conda-forge
dependencies:
  - python=3.12
  - jupyterlab
  - ipykernel
  - numpy
  - scipy
  - matplotlib
  - astropy
  - healpy
  - reproject
  - xarray
  - dask
  - distributed
  - h5py
  - zarr
  - numba
  - pip
YAML

cat > envs/device-controller-dev.yml <<'YAML'
name: device-controller-dev
channels:
  - conda-forge
dependencies:
  - python=3.12
  - jupyterlab
  - ipykernel
  - pyserial
  - asyncssh
  - aiohttp
  - pyzmq
  - pydantic
  - fastapi
  - numpy
  - scipy
  - pip
YAML

cat > envs/docs.yml <<'YAML'
name: docs
channels:
  - conda-forge
dependencies:
  - python=3.12
  - jupyterlab
  - ipykernel
  - nodejs
  - sphinx
  - myst-parser
  - mystmd
  - pydata-sphinx-theme
  - sphinx-autodoc-typehints
  - sphinx-copybutton
  - nbconvert
  - pandoc
  - pip:
      - myst
YAML

cat > envs/uirapuru-dev.yml <<'YAML'
name: uirapuru-dev
channels:
  - conda-forge
dependencies:
  - python=3.12
  - jupyterlab
  - ipykernel
  - numpy
  - scipy
  - astropy
  - h5py
  - xarray
  - dask
  - pip
YAML

# --- scripts ---
cat > scripts/install_miniforge.sh <<'SH'
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
SH
chmod +x scripts/install_miniforge.sh

cat > scripts/setup_env.sh <<'SH'
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
SH
chmod +x scripts/setup_env.sh

cat > scripts/enable_extensions.sh <<'SH'
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
SH
chmod +x scripts/enable_extensions.sh

cat > scripts/register_kernels.sh <<'SH'
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
SH
chmod +x scripts/register_kernels.sh

cat > scripts/clean_envs.sh <<'SH'
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
SH
chmod +x scripts/clean_envs.sh

# --- utils ---
cat > utils/sync_repo.sh <<'SH'
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
SH
chmod +x utils/sync_repo.sh

cat > utils/purge_temp.py <<'PY'
#!/usr/bin/env python3
import os, shutil, sys
from pathlib import Path
targets = [
    Path.home()/".cache/pip",
    Path.home()/".cache/jupyter",
    Path.home()/".local/share/jupyter/runtime",
    Path.home()/".ipynb_checkpoints"
]
for t in targets:
    if t.exists():
        try:
            if t.is_dir():
                shutil.rmtree(t)
                print(f"Removed {t}")
            else:
                t.unlink()
                print(f"Removed {t}")
        except Exception as e:
            print(f"Could not remove {t}: {e}", file=sys.stderr)
PY
chmod +x utils/purge_temp.py

cat > utils/check_gpu.py <<'PY'
#!/usr/bin/env python3
import subprocess, sys
def has_nvidia_smi():
    try:
        out = subprocess.check_output(['nvidia-smi','--query-gpu=name,memory.total,driver_version','--format=csv,noheader,nounits'], stderr=subprocess.DEVNULL)
        print(out.decode())
        return True
    except Exception:
        return False
if __name__ == '__main__':
    if has_nvidia_smi():
        print('NVIDIA GPU appears present.')
    else:
        print('nvidia-smi not available or no NVIDIA GPU present.')
PY
chmod +x utils/check_gpu.py

# Makefile
cat > Makefile <<'MK'
ENV?=base-env

.PHONY: bootstrap envs env update update-env register-kernels clean help

help:
	@echo "Targets:"
	@echo "  make bootstrap            # install miniforge to $$HOME/miniforge3"
	@echo "  make envs                 # create all envs in envs/"
	@echo "  make env ENV=radioastro-full  # create single env (use filename without extension or path)"
	@echo "  make update               # update all envs from envs/*.yml"
	@echo "  make update-env ENV=docs  # update one env"
	@echo "  make register-kernels     # register kernels for all envs"
	@echo "  make clean ENV=name       # remove env by name or use --all in script"

bootstrap:
	bash scripts/install_miniforge.sh

envs:
	@echo "[INFO] Creating/updating all envs..."
	for f in envs/*.yml; do \
		name=$$(sed -n 's/^name:[[:space:]]*//p' $$f | head -n1); \
		if [ -n "$$name" ]; then \
			bash scripts/setup_env.sh "$$f"; \
		fi; \
	done

env:
	bash scripts/setup_env.sh $(ENV)

update:
	@echo "[INFO] Updating all envs..."
	for f in envs/*.yml; do \
		bash scripts/setup_env.sh "$$f"; \
	done

update-env:
	bash scripts/setup_env.sh $(ENV)

register-kernels:
	bash scripts/register_kernels.sh

clean:
	bash scripts/clean_envs.sh $(ENV)
MK

# README
cat > README.md <<'MD'
# JupyterHub Environments (template)

This repository provides a collection of Conda environment YAMLs, helper scripts and utilities
for setting up a shared JupyterHub environment for students in radioastronomy.

## Included environments
- base-env: minimal development environment with jupyterlab, LSP and formatting tools
- radioastro-full: full-featured radioastronomy environment (astropy, healpy, reproject, dask, etc.)
- radioastro-minimal: lightweight starter environment
- cosmology-sim: environment for cosmology simulations and inference
- tod-processing: TOD/mapmaking focused environment
- device-controller-dev: environment for device control and drivers
- docs: documentation environment (Sphinx + MyST)
- uirapuru-dev: placeholder for your private UIRAPURU environment

## Quickstart
1. Install Miniforge (non-root):

    make bootstrap

2. Create one environment (example):

    make env ENV=radioastro-full

3. Register kernels for all envs:

    make register-kernels

4. Install common JupyterLab extensions (activate desired env first):

    conda activate base-env
    bash scripts/enable_extensions.sh

## VSCode Remote SSH
1. Install the *Remote - SSH* extension in VSCode.
2. Add an entry to your `~/.ssh/config`:

    Host jupyterhub
        HostName <JUPYTERHUB_HOST>
        User <your-username>
        IdentityFile ~/.ssh/id_rsa

3. Connect via Remote-SSH and use the Python extension to select the remote interpreter
   from the conda environment (e.g. $HOME/miniforge3/envs/radioastro-full/bin/python).

## Notes
- The scripts try to be idempotent and safe; please inspect before running on production systems.
- Building JupyterLab extensions may require node and can take several minutes.
- For GPU-supporting envs, ensure NVIDIA drivers + CUDA are installed on the host.
MD

# create zip
ZIP_FILE="${PWD}/jupyterhub_envs_v2.zip"
if command -v zip >/dev/null 2>&1; then
  echo "[INFO] Creating zip at $ZIP_FILE"
  zip -r "$ZIP_FILE" . -x "*/__pycache__/*"
else
  echo "[INFO] 'zip' not found; creating tar.gz instead at jupyterhub_envs_v2.tar.gz"
  tar czf jupyterhub_envs_v2.tar.gz .
fi

echo "[DONE] Project and archive created in $ROOT_DIR"
echo "[DONE] ZIP (if created) is at: $ZIP_FILE"

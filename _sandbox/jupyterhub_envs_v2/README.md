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

#!/bin/bash

# Function to display messages, download files, and clone repositories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/logging.sh"
source "${SCRIPT_DIR}/lib/download.sh"
source "${SCRIPT_DIR}/lib/checkout_from_repo.sh"

log "Step 1: Installing Python packages using Conda and Pip..."
yaml_file="${SCRIPT_DIR}/colab_env.yaml"
if conda env update --name base --file ${yaml_file} --prune; then
  log "Python packages installed successfully."
else
  error "Failed to install Python packages. Ensure Conda is installed and the YAML file exists."
  exit 1
fi

log "Step 2: Cloning data repositories..."
# Phenix Project geostd (restraint) library
goestd_repo="https://github.com/phenix-project/geostd.git"
get_repo "$goestd_repo" "geostd"

# temporarily check out prody from repo for numpy 2 compatibility
prody_repo="https://github.com/prody/ProDy.git"
get_repo "$prody_repo" "prody"
cd prody; pip install .; cd ..

log "Step 3: Downloading executables..."
download_autodock_gpu "1.6"

log "Colab environment setup completed successfully!"

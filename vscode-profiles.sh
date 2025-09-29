#!/bin/bash
#
# This script configures VS Code profiles and extensions.

# Exit immediately if a command exits with a non-zero status.
set -e

# ------------------------------------------------------------------------------
# LOGGING
# ------------------------------------------------------------------------------

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# ------------------------------------------------------------------------------
# VS CODE PROFILES & EXTENSIONS
# ------------------------------------------------------------------------------

log "Creating VS Code profiles and installing extensions..."

# Python Profile
log "Setting up Python profile..."
DONT_PROMPT_WSL_INSTALL=1 code --profile "python" --install-extension ms-python.python
DONT_PROMPT_WSL_INSTALL=1 code --profile "python" --install-extension ms-python.vscode-pylance
DONT_PROMPT_WSL_INSTALL=1 code --profile "python" --install-extension ms-python.debugpy
DONT_PROMPT_WSL_INSTALL=1 code --profile "python" --install-extension ms-python.black-formatter

# Terraform Profile
log "Setting up Terraform profile..."
DONT_PROMPT_WSL_INSTALL=1 code --profile "terraform" --install-extension hashicorp.terraform
DONT_PROMPT_WSL_INSTALL=1 code --profile "terraform" --install-extension hashicorp.hcl
DONT_PROMPT_WSL_INSTALL=1 code --profile "terraform" --install-extension tfsec.tfsec

# Golang Profile
log "Setting up Golang profile..."
DONT_PROMPT_WSL_INSTALL=1 code --profile "golang" --install-extension golang.go

# Shell Profile
log "Setting up Shell profile..."
DONT_PROMPT_WSL_INSTALL=1 code --profile "shell" --install-extension ms-vscode.shell-format
DONT_PROMPT_WSL_INSTALL=1 code --profile "shell" --install-extension timonwong.shellcheck

log "VS Code setup complete!"

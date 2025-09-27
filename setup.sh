#!/bin/bash
#
# Setup script for a new WSL Ubuntu 24.04 instance
#
# This script installs and configures a development environment with the
# following tools:
#   - Zsh
#   - Starship
#   - fzf, zoxide
#   - bat
#   - Terraform
#   - GitHub CLI
#   - FiraCode Nerd Font

# Exit immediately if a command exits with a non-zero status.
set -e

LOG_FILE=~/setup.log
exec &> >(tee -a "$LOG_FILE")

# ------------------------------------------------------------------------------
# LOGGING
# ------------------------------------------------------------------------------

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

log_package_install() {
  PACKAGE_NAME=$1
  if dpkg -s "$PACKAGE_NAME" &> /dev/null; then
    log "$PACKAGE_NAME is already installed."
  else
    log "Installing $PACKAGE_NAME..."
    sudo apt-get install -y "$PACKAGE_NAME"
  fi
}

# ------------------------------------------------------------------------------
# INITIAL SETUP & ESSENTIAL TOOLS
# ------------------------------------------------------------------------------

log "Updating and upgrading system packages..."
sudo apt-get update && sudo apt-get upgrade -y

log "Installing essential tools..."
ESSENTIAL_PACKAGES=(curl wget git unzip build-essential stow vim)
for package in "${ESSENTIAL_PACKAGES[@]}"; do
  log_package_install "$package"
done

# ------------------------------------------------------------------------------
# ZSH & DEFAULT SHELL
# ------------------------------------------------------------------------------

log_package_install "zsh"

log "Setting Zsh as the default shell..."
chsh -s $(which zsh)

# ------------------------------------------------------------------------------
# VIM & VIM-PLUG
# ------------------------------------------------------------------------------

if [ -f ~/.vim/autoload/plug.vim ]; then
  log "vim-plug is already installed."
else
  log "Installing vim-plug..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# ------------------------------------------------------------------------------
# INSTALL DEVELOPMENT TOOLS
# ------------------------------------------------------------------------------

log "Installing development tools..."
DEV_PACKAGES=(fzf zoxide bat htop)
for package in "${DEV_PACKAGES[@]}"; do
  log_package_install "$package"
done

log "Creating alias for bat..."
echo "alias cat='batcat'" >> ~/.zshrc

if command -v starship &> /dev/null; then
  log "Starship is already installed."
else
  log "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

log "Installing Chromium..."
log_package_install "chromium-browser"

if command -v terraform &> /dev/null; then
  log "Terraform is already installed."
else
  log "Installing Terraform..."
  log_package_install "gpg"
  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt-get update && log_package_install "terraform"
fi

if command -v gh &> /dev/null; then
  log "GitHub CLI is already installed."
else
  log "Installing GitHub CLI..."
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt-get update && log_package_install "gh"
fi



if [ -d /usr/local/go ]; then
  log "Go (Golang) is already installed."
else
  log "Installing Go (Golang)..."
  GO_VERSION_STRING=$(curl -s "https://go.dev/VERSION?m=text" | head -n 1 | awk '{print $1}')
  GO_VERSION_TARBALL="${GO_VERSION_STRING}.linux-amd64.tar.gz"
  wget "https://go.dev/dl/${GO_VERSION_TARBALL}"
  sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "${GO_VERSION_TARBALL}"
  rm "${GO_VERSION_TARBALL}"
fi

# ------------------------------------------------------------------------------
# NVM, NODE.JS & NPM
# ------------------------------------------------------------------------------

if [ -d ~/.nvm ]; then
  log "NVM is already installed."
else
  log "Installing NVM..."
  NVM_VERSION=$(curl -sI https://github.com/nvm-sh/nvm/releases/latest | grep -i location | awk -F '/' '{print $NF}')
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

log "Installing latest LTS version of Node.js..."
nvm install --lts

# ------------------------------------------------------------------------------
# GEMINI CLI
# ------------------------------------------------------------------------------

if command -v gemini &> /dev/null; then
  log "Gemini CLI is already installed."
else
  log "Installing Gemini CLI..."
  npm install -g @google/gemini-cli
fi

if command -v docker &> /dev/null; then
  log "Docker is already installed."
else
  log "Installing Docker..."
  log_package_install "ca-certificates"
  log_package_install "curl"
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  DOCKER_PACKAGES=(docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin)
  for package in "${DOCKER_PACKAGES[@]}"; do
    log_package_install "$package"
  done
fi

log "Adding user to the docker group to run docker without sudo..."
sudo groupadd docker || true
sudo usermod -aG docker $USER

# ------------------------------------------------------------------------------
# FONT INSTALLATION
# ------------------------------------------------------------------------------

log "Installing FiraCode Nerd Font..."
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
unzip FiraCode.zip -d ~/.local/share/fonts
rm FiraCode.zip
fc-cache -f -v

# ------------------------------------------------------------------------------
# DOTFILES & ZSH CONFIGURATION
# ------------------------------------------------------------------------------

log "Creating dotfiles directory..."
mkdir -p ~/dotfiles/zsh
mkdir -p ~/dotfiles/vim
mkdir -p ~/dotfiles/starship

log "Copying .zshrc to dotfiles directory..."
cp .zshrc ~/dotfiles/zsh/.zshrc

log "Copying .vimrc to dotfiles directory..."
cp .vimrc ~/dotfiles/vim/.vimrc

log "Copying starship.toml to dotfiles directory..."
cp starship.toml ~/dotfiles/starship/starship.toml

log "Stowing dotfiles..."

if [ -f ~/.zshrc ] && [ ! -L ~/.zshrc ]; then
  log "Backing up existing ~/.zshrc to ~/.zshrc.bak"
  mv ~/.zshrc ~/.zshrc.bak
fi
stow -d ~/dotfiles -t ~ zsh

if [ -f ~/.vimrc ] && [ ! -L ~/.vimrc ]; then
  log "Backing up existing ~/.vimrc to ~/.vimrc.bak"
  mv ~/.vimrc ~/.vimrc.bak
fi
stow -d ~/dotfiles -t ~ vim
stow -d ~/dotfiles -t ~ starship

log "Installing vim plugins..."
vim +PlugInstall +qall

# ------------------------------------------------------------------------------
# FINAL INSTRUCTIONS
# ------------------------------------------------------------------------------

log "Setup complete!"
echo "Please restart your shell or run 'source ~/.zshrc' to apply the changes."
echo "You may also need to configure your terminal to use the FiraCode Nerd Font."

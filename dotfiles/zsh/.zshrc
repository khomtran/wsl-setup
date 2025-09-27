# ~/.zshrc
#
# This file is the configuration file for the Z shell (zsh).
# It is sourced when zsh is started.

# ------------------------------------------------------------------------------
# ZINIT PLUGIN MANAGER
# ------------------------------------------------------------------------------

# Location to store zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download zinit, if it's not there
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ------------------------------------------------------------------------------
# ZINIT PLUGINS
# ------------------------------------------------------------------------------

# Basic plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-history-substring-search

# Snippets from Oh My Zsh
zinit snippet OMZP::aws
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::gh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::terraform
zinit snippet OMZP::command-not-found

zinit cdreplay -q

# ------------------------------------------------------------------------------
# HISTORY
# ------------------------------------------------------------------------------

# Keep 10000 lines of history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

# History settings
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ------------------------------------------------------------------------------
# COMPLETION
# ------------------------------------------------------------------------------

# Use modern completion system
autoload -Uz compinit && compinit

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ------------------------------------------------------------------------------
# ALIASES
# ------------------------------------------------------------------------------

alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias tfl='tflint -c $HOME/terraform/.tflint.hcl'

# ------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES & PATH
# ------------------------------------------------------------------------------

export PATH=$PATH:$HOME/octocli/:/usr/local/go/bin:$HOME/.local/bin/:
export GCM_CREDENTIAL_STORE=secretservice

# ------------------------------------------------------------------------------
# NVM (NODE VERSION MANAGER) - LAZY LOADING
# ------------------------------------------------------------------------------

export NVM_DIR="$HOME/.nvm"
# Defer initialization of nvm until it's actually used
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm
# Add every nvm-managed node version to the PATH
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ------------------------------------------------------------------------------
# INITIALIZATION
# ------------------------------------------------------------------------------

eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"

# . "$HOME/.local/bin/env"

# End of ~/.zshrc
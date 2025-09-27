# WSL Zsh Development Environment

This directory contains configuration files for setting up a WSL (Windows Subsystem for Linux) development environment with Zsh.

## Key Files

*   `.zshrc`: This is the main configuration file for Zsh. It sets up the prompt, command history, plugins, aliases, and environment variables.
*   `setup.sh`: A script to automate the installation of tools and configuration of the environment on a fresh WSL Ubuntu 24.04 instance. It uses `stow` to manage dotfiles.
*   `setup_vscode.sh`: A script to configure VS Code profiles and extensions.
*   `.vimrc`: Configuration file for the Vim editor, including a list of plugins.

## Usage

1.  Run the `setup.sh` script to install all the necessary tools and fonts.
2.  Run the `setup_vscode.sh` script to configure VS Code profiles and extensions.
3.  The script will use `stow` to create symbolic links for `.zshrc` and `.vimrc`.
4.  Restart your shell or source `~/.zshrc` to apply the changes.

## Recreation Prompt

Use the following prompt to regenerate the `setup.sh`, `setup_vscode.sh`, `.zshrc` and `.vimrc` files with an AI model.

---

**Prompt:**

Generate a `setup.sh` script, a `setup_vscode.sh` script, a `.zshrc` file, and a `.vimrc` file for a WSL Ubuntu 24.04 development environment.

The `setup.sh` script should install:
- Zsh and set it as the default shell.
- Essential tools: curl, wget, git, unzip, build-essential, stow, vim.
- Development tools: fzf, zoxide, bat, htop.
- Starship prompt.
- Terraform.
- GitHub CLI.
- Go (latest version).
- NVM (Node Version Manager), Node.js (latest LTS), and npm.
- Gemini CLI (via npm).
- Docker and Docker Compose.
- FiraCode Nerd Font.

The `setup.sh` script should also:
- Include a logging function that timestamps and logs every action, saving the output to `~/setup.log`.
- Add the user to the docker group.
- Use `stow` to manage dotfiles. It should create a `~/dotfiles/zsh` and `~/dotfiles/vim` directory, copy the `.zshrc` and `.vimrc` files into them, and then use `stow` to create the symbolic links.

The `setup_vscode.sh` script should:
- Create VS Code profiles for Python, Terraform, Golang, and Shell.
- Install relevant extensions for each profile.
- Suppress any prompts from VS Code during the installation.

The `.zshrc` file should configure:
- `zinit` as a plugin manager.
- Zinit plugins:
    - `zsh-users/zsh-syntax-highlighting`
    - `zsh-users/zsh-completions`
    - `zsh-users/zsh-autosuggestions`
    - `Aloxaf/fzf-tab`
    - `zsh-users/zsh-history-substring-search`
- Oh My Zsh snippets for: `aws`, `docker`, `docker-compose`, `gh`, `git`, `sudo`, `terraform`, `command-not-found`.
- History settings (size, file, options).
- Modern completion system.
- Aliases: `ls`, `ll`, `la`, `l`, `tfl`.
- Environment variables for `octocli`, `go`, and `nvm`.
- Lazy loading for `nvm`.
- Initialization for `fzf`, `zoxide`, and `starship`.

The `.vimrc` file should configure:
- `vim-plug` as a plugin manager.
- vim-plug plugins:
    - `vim-airline/vim-airline`
    - `vim-airline/vim-airline-themes`
    - `preservim/nerdtree`
    - `tpope/vim-fugitive`
    - `tpope/vim-surround`
    - `tpope/vim-commentary`
    - `junegunn/fzf`, `junegunn/fzf.vim`
    - `gruvbox-community/gruvbox`
- Basic Vim settings like line numbers, colorscheme, and plugin configurations.

---
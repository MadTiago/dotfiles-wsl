#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Install packages
sudo apt update
sudo apt install -y \
	curl \
	git \
	zsh \
	direnv \
	stow \
	bat \
	ripgrep

# Install antibody
curl -sfL https://git.io/antibody | sudo sh -s -- -b /usr/local/bin

# zsh path
ZSH_PATH="$(command -v zsh)"

# Bundle zsh plugins
antibody bundle < "$SCRIPT_DIR/zsh/.zsh_plugins.txt" > "$SCRIPT_DIR/zsh/.zsh_plugins.sh"

# Create .fonts directory if it doesn't exist
mkdir -p "$HOME/.fonts"

# Stow dotfiles
stow --dir="$SCRIPT_DIR" --target="$HOME" zsh
stow --dir="$SCRIPT_DIR" --target="$HOME/.fonts" fonts

# Install oh-my-zsh
# --unattended will not try to change the default shell, and it also won't run zsh when the installation has finished
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

# Refresh fonts cache
fc-cache -fv

# Make zsh the default shell
sudo chsh -s $ZSH_PATH $USER
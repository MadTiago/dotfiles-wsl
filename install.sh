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

# Install antidote
if [ ! -d "$HOME/.antidote" ]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
fi

# zsh path
ZSH_PATH="$(command -v zsh)"

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
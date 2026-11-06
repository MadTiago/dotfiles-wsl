#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Install nix
if [ ! -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
	curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
fi

# Source nix
source ~/.nix-profile/etc/profile.d/nix.sh

# Install packages
nix-env -iA \
	nixpkgs.zsh \
	nixpkgs.antibody \
	nixpkgs.git \
	nixpkgs.direnv \
	nixpkgs.bat \
	nixpkgs.stow \
	nixpkgs.fzf \
	nixpkgs.ripgrep

# Add zsh to valid shells
ZSH_PATH="$(command -v zsh)"
grep -Fxq "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells

# Bundle zsh plugins
antibody bundle < "$SCRIPT_DIR/zsh/.zsh_plugins.txt" > "$SCRIPT_DIR/zsh/.zsh_plugins.sh"

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Create .fonts directory if it doesn't exist
mkdir -p "$HOME/.fonts"

# Stow dotfiles
stow --dir="$SCRIPT_DIR" --target="$HOME" zsh
stow --dir="$SCRIPT_DIR" --target="$HOME/.fonts" fonts

# Refresh fonts cache
fc-cache -fv

# Make zsh the default shell
sudo chsh -s $ZSH_PATH $USER
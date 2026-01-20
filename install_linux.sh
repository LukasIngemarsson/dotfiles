#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "--------------------------------------------------"
echo "Starting Linux Setup (WSL/Debian/Ubuntu)"
echo "--------------------------------------------------"

# 1. Update & Install Core Tools
echo "[+] Installing Apt Packages..."
sudo apt update
sudo apt install -y git zsh tmux neovim ripgrep fzf nodejs npm python3-venv unzip

# 2. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[+] Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. Clone Zsh Plugins
echo "[+] Installing Zsh Plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting 2>/dev/null || true
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k 2>/dev/null || true

# 4. Symlinks
echo "[+] Linking Dotfiles..."
mkdir -p "$HOME/.config"

rm -rf "$HOME/.zshrc" "$HOME/.tmux.conf"
ln -s "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -s "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"

rm -rf "$HOME/.config/nvim"
ln -s "$DOTFILES/nvim" "$HOME/.config/nvim"

# Change Shell
echo "[+] Changing default shell to zsh..."
sudo chsh -s $(which zsh) $USER

echo "--------------------------------------------------"
echo "Linux Setup Complete."
echo "NOTE: Install VS Code manually (Snap, Apt, or Windows Exe)."

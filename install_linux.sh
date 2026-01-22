#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "--------------------------------------------------"
echo "Starting Linux Setup (WSL/Debian/Ubuntu)"
echo "--------------------------------------------------"

# 1. Update & Install Core Tools
echo "[+] Installing Apt Packages..."
sudo apt-get update
sudo apt-get install -y git zsh tmux neovim ripgrep fzf nodejs npm python3-venv unzip

# 2. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[+] Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "[*] Oh My Zsh is already installed. Skipping."
fi

# 3. Clone Zsh Plugins
echo "[+] Installing Zsh Plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting 2>/dev/null || true
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k 2>/dev/null || true

# 4. Symlinks
echo "[+] Linking Dotfiles..."
mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -sfn "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
ln -sfn "$DOTFILES/.config/nvim" "$HOME/.config/nvim"

# 5. Setup Tmux Plugin Manager
echo "[+] Setting up Tmux..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    echo "[*] Tmux Plugin Manager is already installed. Skipping."
fi
# Run the installer script, but avoid erroring if tmux server isn't running
"$HOME/.tmux/plugins/tpm/bin/install_plugins" || true

# 6. Change Shell
if [ "$(basename "$SHELL")" != "zsh" ]; then
    echo "[+] Changing default shell to zsh..."
    chsh -s "$(which zsh)" "$USER"
else
    echo "[*] Default shell is already zsh. Skipping."
fi

echo "--------------------------------------------------"
echo "Linux Setup Complete."
echo "NOTE: Log out and log back in for the shell change to take effect."

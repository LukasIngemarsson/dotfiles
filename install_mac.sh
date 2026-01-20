#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "--------------------------------------------------"
echo "Starting macOS Setup"
echo "--------------------------------------------------"

# 1. Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "[+] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. Install Tools
echo "[+] Installing Binaries..."
brew install git node pyenv fzf ripgrep tmux neovim bash
brew install --cask karabiner-elements visual-studio-code iterm2 rectangle mos

# 3. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[+] Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 4. Clone Zsh Plugins
echo "[+] Installing Zsh Plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting 2>/dev/null || true
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k 2>/dev/null || true

# 5. Symlinks
echo "[+] Linking Dotfiles..."
mkdir -p "$HOME/.config"

rm -rf "$HOME/.zshrc" "$HOME/.tmux.conf"
ln -s "$DOTFILES/.zshrc" "$HOME/.zshrc"

ln -s "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"

rm -rf "$HOME/.config/nvim"
ln -s "$DOTFILES/nvim" "$HOME/.config/nvim"

rm -rf "$HOME/.config/karabiner"
ln -s "$DOTFILES/.config/karabiner" "$HOME/.config/karabiner"

# 6. Setup Tmux Plugin Manager
echo "[+] Setting up Tmux..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

# 6. Configure iTerm2
echo "[+] Configuring iTerm2..."
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# 7. General Preferences
defaults write -g applepressandholdenabled -bool false # disable hold for special chars

echo "--------------------------------------------------"
echo "macOS Setup Complete."

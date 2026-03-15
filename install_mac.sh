#!/bin/bash
set -e

DOTFILES="$HOME/coding-workspace/dotfiles"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# homebrew
if ! command -v brew &> /dev/null; then
    echo "[+] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "[*] Homebrew is already installed. Skipping."
fi

# install tools and apps
echo "[+] Installing tools with Homebrew..."
brew bundle --file=- <<EOF
# Binaries
brew "git"
brew "node"
brew "pyenv"
brew "fzf"
brew "ripgrep"
brew "tmux"
brew "neovim"
brew "bash"

# Casks
cask "karabiner-elements"
cask "visual-studio-code"
cask "iterm2"
cask "rectangle"
cask "mos"
EOF

# oh my zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[+] Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "[*] Oh My Zsh is already installed. Skipping."
fi

# zsh plugins
echo "[+] Installing Zsh Plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting 2>/dev/null || true
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k 2>/dev/null || true

# symlinks
echo "[+] Linking Dotfiles..."
mkdir -p "$HOME/.config"

ln -sfn "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -sfn "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
ln -sfn "$DOTFILES/.config/nvim" "$HOME/.config/nvim"
ln -sfn "$DOTFILES/.config/karabiner" "$HOME/.config/karabiner"

# tmux plugin manager
echo "[+] Setting up Tmux..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    echo "[*] Tmux Plugin Manager is already installed. Skipping."
fi
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

# iterm 2 config
echo "[+] Configuring iTerm2..."
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# general config
echo "[+] Setting macOS preferences..."
defaults write -g applepressandholdenabled -bool false # disable hold for special chars
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.2
defaults write com.apple.dock "mru-spaces" -bool "false" # disable desktops from rearranging
killall Dock
defaults write com.apple.finder NewWindowTarget 'PfHm' # open new finder windows from home
killall Finder

echo
echo "[!] Done! Open a new terminal instance for all the changes to take effect."
echo "[!] NOTE: To properly render icons in the terminal, download a nerd font from https://www.nerdfonts.com."


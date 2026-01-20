# Dotfiles

## Installation

Note: If you clone this repository to a location other than `~/dotfiles`, you must open the installation script (`install_mac.sh` or `install_linux.sh`) and update the `DOTFILES` variable at the top of the file to match your chosen path.

### Run Setup Script

For macOS:

```bash
chmod +x install_mac.sh
./install_mac.sh

```

For WSL/Debian/Ubuntu:

```bash
chmod +x install_linux.sh
./install_linux.sh

```

---

## VS Code Setup (Native Sync)

To avoid conflicts with the native "Settings Sync" feature in VS Code, these settings are not symlinked.

To restore your extensions, settings, and keybindings:

1. Open VS Code.
2. Click the Accounts icon (person icon) in the bottom-left of the Activity Bar.
3. Select "Turn on Settings Sync...".
4. Select "Sign in & Turn on".
5. Log in with your GitHub account.
6. Select the options you want to sync (Settings, Keyboard Shortcuts, Extensions, etc.) and confirm.

---

## Post-Install Checklist

After the script finishes, complete these manual steps:

1. Karabiner (Mac Only):
* Open `Karabiner-Elements`.
* Go to `System Settings` > `Privacy & Security` > `Input Monitoring` and enable Karabiner.
* Restart the Karabiner app if necessary.

2. Neovim:
* Open `nvim`.
* Wait for the package manager (Lazy/Mason) to install dependencies automatically.
* If you see errors, run `:checkhealth`.

3. Restart:
* Close and re-open your terminal to load the new zsh configuration.


# --- INSTANT PROMPT ---

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- OMZ VARIABLES ---

export ZSH="$HOME/.oh-my-zsh"

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

ZSH_THEME="powerlevel10k/powerlevel10k"

export PATH="$HOME/.fzf/bin:$PATH"

# --- ENV & PATHS ---

# homebrew
export PATH="/opt/homebrew/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# c++
export CPLUS_INCLUDE_PATH="$HOME/.local/include:$CPLUS_INCLUDE_PATH"

# --- OMZ PLUGINS ---

source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

plugins=(git zsh-syntax-highlighting)

fpath+=$ZSH_CUSTOM/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# --- ALIASES ---

alias vim="nvim"

# --- INIT ---

# PowerLevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Conda
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# FZF
eval "$(fzf --zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

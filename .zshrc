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

# user-local binaries (for pip --user and other tools)
export PATH="$HOME/.local/bin:$PATH"

# --- OMZ PLUGINS ---

source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

plugins=(git zsh-syntax-highlighting)

fpath+=$ZSH_CUSTOM/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# --- ALIASES ---

alias vim="nvim"

# --- FUNCTIONS ---

use-default-stack() {
  local claude_md="CLAUDE.md"
  cat >> "$claude_md" <<'EOF'

## Tech Stack

- **Framework**: SvelteKit with TypeScript
- **Styling**: Tailwind CSS with DaisyUI components
- **Backend/DB**: Supabase (when a backend or database is needed)
- **Deployment**: Vercel (when deployment is needed)
- Use other relevant APIs and libraries as appropriate for the task at hand
EOF
  echo "Default tech stack added to $claude_md."
}

init-git-rules() {
  mkdir -p .claude/rules
  cp "$HOME/coding-workspace/dotfiles/claude/git.md" .claude/rules/git.md
  echo "Claude git rules added to $(basename "$PWD")."
}

create-git-repo() {
  if [[ -z "$1" ]]; then
    echo "Usage: create-git-repo <name>"
    return 1
  fi
  gh repo create "$1" --private --clone \
    && cd "$1" \
    && git commit --allow-empty -m "initial commit" \
    && git push \
    && gh api "repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/branches/main/protection" \
        --method PUT \
        --input - <<'EOF'
{
  "required_pull_request_reviews": {
    "required_approving_review_count": 0
  },
  "enforce_admins": false,
  "required_status_checks": null,
  "restrictions": null
}
EOF
  echo "Repo '$1' created with main branch protection."
}

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

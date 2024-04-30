# Zsh settings
ZSH_THEME="robbyrussell"

# Oh My Zsh settings
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)
source $ZSH/oh-my-zsh.sh
HISTFILE=$ZDOTDIR/.zsh_history

# Homebrew setup
eval "$(/opt/homebrew/bin/brew shellenv)"

# CLI tools
eval "$(fzf --zsh)"
source /Users/Teia/.config/broot/launcher/bash/br

# Bat aliases
alias fp='fzf --preview "bat --style numbers,changes --color=always {}" | head -500'

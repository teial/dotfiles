# Google Cloud SDK
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# Node
export NVM_DIR="$HOME/.config/nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Rust
. "$HOME/.cargo/env"

# Elixir
export ERL_AFLAGS="-kernel shell_history enabled"

# Haskell
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

# Python
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# SDKMan
export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

# C++
CXXFLAGS="-std=c++20 -Wall -Wextra -Wpedantic -Werror -Weffc++"
alias g++="g++-13 $CXXFLAGS"


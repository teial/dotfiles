set fish_path $HOME/.config/fish
set fish_greeting
set fish_color_valid_path

. $fish_path/aliases.fish
. $fish_path/openai.fish

# Set XDG paths.
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_BIN_HOME "$HOME/.local/bin"
set -gx XDG_TOOL_HOME "$HOME/.tool" # For tools that don't respect XDG conventions
fish_add_path -ga "$XDG_BIN_HOME"

if status is-interactive
    # Set up homebrew.
    if test -d /home/linuxbrew/.linuxbrew # Linux
        set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
        set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
        set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/Homebrew"
    else if test -d /opt/homebrew # MacOS
        set -gx HOMEBREW_PREFIX /opt/homebrew
        set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
        set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/homebrew"
    end

    ! set -q MANPATH; and set MANPATH ''
    set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH

    ! set -q INFOPATH; and set INFOPATH ''
    set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH

    fish_add_path -ga "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"

    # Fix GPG mess with terminal.
    export GPG_TTY=$(tty)

    # Rust setup.
    set -gx RUSTUP_HOME "$XDG_TOOL_HOME/rustup"
    set -gx CARGO_HOME "$XDG_TOOL_HOME/cargo"
    fish_add_path -gP "$CARGO_HOME/bin"

    # Haskell setup.
    set -gx GHCUP_USE_XDG_DIRS 1
    fish_add_path -gP "$GHCUP_INSTALL_BASE_PREFIX//bin"

    # Node and yarn paths.
    nvm use latest
    fish_add_path -gP "$HOME/.yarn/bin"

    # Java setup.
    fish_add_path -gP /opt/homebrew/opt/openjdk/bin

    # Set up doom emacs.
    fish_add_path -gP "$XDG_CONFIG_HOME/emacs/bin"

    # Set up CLI tools.
    fzf --fish | source
    zoxide init --cmd cd fish | source

    # Set up XDG compliance for other tools.
    set -gx LESSHISTFILE "$XDG_STATE_HOME/less/history"

    # Additional libraries for compliation.
    set -gx LDFLAGS "-L/opt/homebrew/opt/zlib/lib -L/opt/homebrew/opt/libiconv/lib"
    set -gx CPPFLAGS "-I/opt/homebrew/opt/zlib/include -I/opt/homebrew/opt/libiconv/include"

    # Customize fish prompt to include virtualfish environment for Python.
    functions -c fish_prompt _old_fish_prompt
    function fish_prompt
        if set -q VIRTUAL_ENV
            echo -n -s (set_color  red) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
        end
        _old_fish_prompt
    end
end

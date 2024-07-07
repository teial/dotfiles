{ config, pkgs, ... }: {
    imports = [ ./zsh ./tmux ];

    home.packages = with pkgs; [
        zoxide
        fzf
        bat
        ripgrep
        htop
        tree
        eza
        direnv
    ];

    # Set up environment variables.
    home.sessionVariables = {
        EDITOR = "nvim";
        BROWSER = "firefox";
        TERMINAL = "alacritty";
        SSH_KEY_PATH = "$HOME/.ssh/id_ed25519";
        SSH_PUB_KEY_PATH = "$HOME/.ssh/id_ed25519.pub";
        XDG_CACHE_HOME  = "${config.xdg.cacheHome}";
        XDG_CONFIG_HOME = "${config.xdg.configHome}";
        XDG_DATA_HOME   = "${config.xdg.dataHome}";
        XDG_STATE_HOME  = "${config.xdg.stateHome}";
    };

    # Some useful aliases
    home.shellAliases = {
        update = "nix run nix-darwin -- switch --flake .";
        gcc = "zig cc";
        "g++" = "zig ++";
        ls = "eza";
    };

    # Enable eza.
    programs.eza.enable = true;

    # Enable zoxide.
    programs.zoxide.enable = true;
    programs.zoxide.enableZshIntegration = true;
    programs.zoxide.options = [ "--cmd" "cd" ];

    # Set up fzf.
    programs.fzf.enable = true;
    programs.fzf.tmux.enableShellIntegration = true;

    # Set up direnv.
    programs.direnv.enable = true;
    programs.direnv.enableZshIntegration = true;
}

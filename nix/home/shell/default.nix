{ config, pkgs, ... }: {

    home.packages = with pkgs; [
        htop
        tree
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

    # Set up direnv.
    programs.direnv.enable = true;
    programs.direnv.enableZshIntegration = true;
}

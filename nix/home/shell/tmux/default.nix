{ pkgs, ... }: let
  # Minimal tmux status plugin must be derived manually.
  tmux-minimal = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "minimal";
    version = "unstable-2024-05-27";
    src = pkgs.fetchFromGitHub {
      owner = "niksingh710";
      repo = "minimal-tmux-status";
      rev = "ee00ccc15a6fdd42b98567602434f7c9131ef89f";
      sha256 = "sha256-tC9KIuEpMNbBbM6u3HZF0le73aybvA7agNBWYksKBDY=";
    };
  };
in {
  home.packages = with pkgs; [ tmux ];

  programs.tmux = {
    # Enable tmux.
    enable = true;

    # Use vi-mode keys.
    keyMode = "vi";

    # Use 24-hour clock.
    clock24 = true;

    # Enable mouse, because sometimes my hands are busy.
    mouse = true;

    # Prefix, the most important option.
    shortcut = "f";

    # Shell, because tmux needs it.
    shell = "${pkgs.zsh}/bin/zsh";

    # Terminal, becase tmux needs it.
    terminal = "screen-256color";

    # The source of my woes vanquished.
    escapeTime = 0;

    # All the plugins for tmux.
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmux-minimal
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];

    # Base config.
    extraConfig = builtins.readFile ./tmux.conf;
  };
}

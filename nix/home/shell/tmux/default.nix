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

  # Tmux autoreladed is another plugin that must be built by hand.
  tmux-autoreload = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "autoreload";
    version = "unstable-2024-05-27";
    src = pkgs.fetchFromGitHub {
      owner = "b0o";
      repo = "tmux-autoreload";
      rev = "e98aa3b74cfd5f2df2be2b5d4aa4ddcc843b2eba";
      sha256 = "sha256-9Rk+VJuDqgsjc+gwlhvX6uxUqpxVD1XJdQcsc5s4pU4=";
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
    terminal = "tmux-256color";

    # Automatically spawn a session if trying to attach and none are running.
    newSession = true;

    # All the plugins for tmux.
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.better-mouse-mode
      tmux-autoreload
      {
        plugin = tmux-minimal;
        extraConfig = "bind-key b set-option status";
      }
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

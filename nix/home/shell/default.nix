{ config, pkgs, ... }: {
  imports = [ ./zsh ./tmux ];

  home.packages = with pkgs; [
    zoxide
    fzf
    bat
    ripgrep
    htop
  ];

  # Set up environment variables.
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    SSH_KEY_PATH = "~/.ssh/id_ed25519";
    SSH_PUB_KEY_PATH = "~/.ssh/id_ed25519.pub";
  };

  # Some useful aliases
  home.shellAliases = {
    update = "nix run nix-darwin -- switch --flake .";
    gcc = "zig cc";
    "g++" = "zig ++";
  };

  # Enable zoxide
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;
  programs.zoxide.options = [ "--cmd" "cd" ];

  # Set up fzf.
  programs.fzf.enable = true;
  programs.fzf.tmux.enableShellIntegration = true;
}

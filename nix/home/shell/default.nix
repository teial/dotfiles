{ config, pkgs, ... }: {
  imports = [ ./zsh ./tmux ];

  home.packages = with pkgs; [ zoxide fzf ];

  # Set up environment variables.
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  # Some useful aliases
  home.shellAliases = {
    update = "nix run nix-darwin -- switch --flake .";
  };

  # Enable zoxide
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;
  programs.zoxide.options = [ "--cmd" "cd" ];

  # Set up fzf.
  programs.fzf.enable = true;
  programs.fzf.tmux.enableShellIntegration = true;
}

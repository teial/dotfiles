{ config, pkgs, ... }:
{
  imports = [ ./zsh ];    

  home.packages = with pkgs; [
    zoxide
  ];

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
}

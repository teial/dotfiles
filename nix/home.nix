{ pkgs, zig, zls, ... }:
{
  home = {
    # Channel version
    stateVersion = "23.11";

    # My user name everywhere
    username = "teial";

    # home directory
    homeDirectory = "/Users/Teia";

    # All my software
    packages = with pkgs; [

      # Git-related
      git
      delta
      git-lfs
      gh

      # Programming languages
      go
      guile

      # Nightly overlays
      zig
      zls
    ];
  };

  # Enable home manager
  programs.home-manager.enable = true;
}


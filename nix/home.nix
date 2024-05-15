{ pkgs, zig, ... }:
{
  home = {
    # Channel version
    stateVersion = "23.11";

    # My user name everywhere
    username = "teial";

    # home directory
    homeDirectory = "/Users/Teia";

    # All my software
    packages = [

      # Git-related
      pkgs.git
      pkgs.delta
      pkgs.git-lfs
      pkgs.gh

      # Nightly overlays
      zig
    ];
  };

  # Enable home manager
  programs.home-manager.enable = true;
}


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
    packages = with pkgs; [

      # Git-related
      git
      delta
      git-lfs
      gh

      # Nightly overlays
      zig
    ];
  };

  # Enable home manager
  programs.home-manager.enable = true;
}


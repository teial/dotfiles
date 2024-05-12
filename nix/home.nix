{ pkgs, ... }: {
  home = {
    stateVersion = "23.11";
    username = "teial";
    homeDirectory = "/Users/Teia";
    packages = [
      pkgs.git
      pkgs.delta
      pkgs.git-lfs
      pkgs.gh
    ];
  };
  programs.home-manager.enable = true;
}


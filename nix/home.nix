{ ... }: {
  # This is required information for home-manager to do its job
  home = {
    stateVersion = "23.11";
    username = "teial";
    homeDirectory = "/Users/Teia";
    packages = [ ];
  };
  programs.home-manager.enable = true;
  # I use fish, but bash and zsh work just as well here. This will setup
  # the shell to use home-manager properly on startup, neat!
  # programs.zsh.enable = true;
}


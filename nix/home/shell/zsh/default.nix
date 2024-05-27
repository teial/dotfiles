{ config, pkgs, ... }: let
  configHome = builtins.baseNameOf config.xdg.configHome;
in {
  home.packages = with pkgs; [
    zsh
    zsh-completions
    zsh-syntax-highlighting
    zsh-history-substring-search
    oh-my-zsh
  ];

  programs.zsh = {
    # Enable zsh.
    enable = true;

    # Location of zsh config.
    dotDir = "${configHome}/zsh";

    # Do not store these commands in history.
    history.ignorePatterns = [ "rm *" "pkill *" ];

    # History file location.
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";

    # Enable autosuggestions.
    autosuggestion.enable = true;

    # Enable autocompletion.
    enableCompletion = true;

    # zsh profile contains login shell config that might be used by other programs.
    profileExtra = builtins.readFile ./zprofile;

    # zshrc contains login shell config that is used by me inside the shell.
    initExtra = builtins.readFile ./zshrc;
  };

  programs.zsh.oh-my-zsh = {
    # Enable oh my zsh
    enable = true;

    # Some plugins
    plugins = [ "git" ];

    # Pick a theme.
    theme = "robbyrussell";
  };
}

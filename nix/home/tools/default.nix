{ pkgs, ... }:
{
    home.packages = with pkgs; [
        # Version control
        git
        delta
        git-lfs
        gh

        # Networking
        curl
        wget
        tcpflow

        # Development
        exercism 
        devenv

        # Other
        stow
        aria2
        gnupg
    ];
}

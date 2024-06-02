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

      # Other
      stow
      aria2
      gnupg
    ];
}

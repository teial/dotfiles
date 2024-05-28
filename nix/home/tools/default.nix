{ pkgs, ... }:
{
    home.packages = with pkgs; [
      # Version control
      git
      delta
      git-lfs
      gh
    ];
}

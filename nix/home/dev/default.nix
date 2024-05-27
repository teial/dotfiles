{ pkgs, ... }:
{
    home.packages = with pkgs; [
      git
      delta
      git-lfs
      gh
    ];
}

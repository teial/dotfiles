{ pkgs, ... }:
{
  # Extra tools (mostly for LSP).
  home.packages = with pkgs; [
    nixfmt-classic
  ];
}

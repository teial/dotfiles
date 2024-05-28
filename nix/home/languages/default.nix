{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    rustup 
    elixir
    erlang
    go
    guile
    zig
    zls
  ];

  programs.go.enable = true;
}

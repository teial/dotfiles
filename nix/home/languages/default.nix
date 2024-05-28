{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    julia-bin
    jdk
    rustup 
    elixir
    erlang
    go
    guile
    zig
    zls
  ];
}

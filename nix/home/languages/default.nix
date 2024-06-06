{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    julia-bin
    jdk
    clang-tools
    rustup 
    elixir
    erlang
    go
    guile
    zig
    zls
    ghc
    stack
    nodejs
  ];
}

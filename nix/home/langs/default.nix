{ config, pkgs, zig, zls, configHome, ... }: let
  configHome = builtins.baseNameOf config.xdg.configHome;
in {
  # TODO: Use https://github.com/nix-community/fenix to set up rust properly
  home.packages = with pkgs; [
    rustup 
    elixir
    erlang
    go
    guile
    zig
    zls
  ];
}

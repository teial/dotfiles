{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
        clang-tools
        elixir
        erlang
        guile
        nodejs
    ];
}

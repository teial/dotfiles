{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
        jdk
        clang-tools
        rustup 
        elixir
        erlang
        guile
        nodejs
    ];
}

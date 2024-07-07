{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
        clang-tools
        rustup 
        elixir
        erlang
        guile
        nodejs
    ];
}

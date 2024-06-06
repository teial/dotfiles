{ config, pkgs, ... }:
{
    programs.neovim = {
        # Enable neovim.
        enable = true;
        
        # Install it here.
        package = pkgs.neovim-unwrapped;

        # Associate neovim with vim command.
        vimAlias = true;

        # Extra packages. This is where the real action happens.
        extraPackages = with pkgs; [

            # Golang
            gofumpt
            goimports-reviser
            golines
            gopls
            delve

            # Lua
            selene
            stylua
            lua-language-server

            # Elixir
            elixir-ls

            # Nix
            nil
            nixfmt-classic

            # Haskell
            haskell-language-server
        ];
    };
}

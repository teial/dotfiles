{
    description = "Teia's nix configuration";

    inputs = {
        # Package sets
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

        # System manager
        darwin.url = "github:LnL7/nix-darwin";
        darwin.inputs.nixpkgs.follows = "nixpkgs";

        # Home manager
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs @ { nixpkgs, home-manager, darwin, ... }: let
        system = "aarch64-darwin";
    in {
        # System configuration for Calypso
        darwinConfigurations.calypso = darwin.lib.darwinSystem {
            inherit system;
            pkgs = import nixpkgs { inherit system; };
            modules = [
                ./hosts/calypso/default.nix
                home-manager.darwinModules.home-manager
                {
                  home-manager.extraSpecialArgs = { inherit inputs; };
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.teial = import ./home;
                }
            ];
        };
    };
}


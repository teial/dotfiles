{ config, pkgs, inputs, ... }:
{
    home = {
        # Channel version
        stateVersion = "23.11";

        # My user name everywhere
        username = "teial";

        # home directory
        homeDirectory = "/Users/Teia";
    };

    # Enable home manager.
    programs.home-manager.enable = true;
}

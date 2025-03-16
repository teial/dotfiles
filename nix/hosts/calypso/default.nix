{ pkgs, ... }:
{
    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

    # Trusted users. Because devenv keeps asking for it.
    nix.settings.trusted-users = [ "root" "teial" ];

    # Set up my shells.
    programs.zsh.enable = true;
    environment.shells = with pkgs; [ bash zsh ];

    # Good to have for all users.
    environment.systemPackages = [ pkgs.coreutils ];

    # Used for backwards compatibility, please read the changelog before changing.
    system.stateVersion = 4;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";

    # Default user (repeated in home-manager)
    users.users.teial = {
        name = "teial";
        home = "/Users/Teia";
    };

    # Set up my keyboard.
    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToControl = true;

    # System settings
    system.defaults = {

        # Finder settings.
        finder.AppleShowAllExtensions = true;
        finder.ShowPathbar = true;

        # Change keyboard repeat rate.
        NSGlobalDomain.InitialKeyRepeat = 15;
        NSGlobalDomain.KeyRepeat = 2;

        # System UI settings.
        dock = {
            # Automatically hide system dock.
            autohide = true;

            # Autohide/show immediately.
            autohide-delay = 0.0;

            # Resanble size for dock icons.
            tilesize = 64;

            # Don't rearrange spaces.
            mru-spaces = false;

            # Apps that should stay in dock no matter what.
            persistent-apps = [
                "/Applications/Alacritty.app"
                "/Applications/Firefox.app"
                "/Applications/Todoist.app"
                "/Applications/Telegram.app"
            ];

            # Corner actions.
            wvous-tl-corner = 2; # mission control
            wvous-bl-corner = 13; # lock screen
            wvous-tr-corner = 11; # launchpad
        };
    };
}

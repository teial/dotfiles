{ pkgs, ... }:
{
    # Make sure the nix daemon always runs
    services.nix-daemon.enable = true;

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

    # Set up my shells.
    programs.zsh.enable = true;
    environment.shells = with pkgs; [ bash zsh ];
    environment.loginShell = pkgs.zsh;

    # Good to have for all users.
    environment.systemPackages = [ pkgs.coreutils ];

    # Used for backwards compatibility, please read the changelog before changing.
    system.stateVersion = 4;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";

    # Add ability to used TouchID for sudo authentication
    security.pam.enableSudoTouchIdAuth = true;

    # Use manually installed homebrew to install casks
    homebrew = {
        # Enable Homebrew
        enable = true;

        # No asking anymore.
        caskArgs.no_quarantine = true;

        # Do not update on each activate since it is so slow
        onActivation.autoUpdate = false;
        onActivation.upgrade = true;

        # Some good casks that I use (I try to keep this to minimum since I live in the terminal anyway)
        casks = [
            "iina"
            "ivpn"
            "telegram"
            "zoom"
            "discord"
            "firefox"
            "google-chrome"
            "alacritty"
        ];

        # Appstore stuff.
        masApps = {};
    };

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
            ];
        };
    };
}

{ pkgs, ... }:
{
  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Use manually installed homebrew to install casks
  homebrew = {

    # enable Homebrew
    enable = true;

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
  };

  # Default user (repeated in home-manager)
  users.users.teial = {
    name = "teial";
    home = "/Users/Teia";
  };

  # System settings
  system.defaults = {

    # Autohide system dock
    dock.autohide = true;
  };
}

{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable FISH Shell
  programs.fish.enable = true;

  # Enable ZSH
  programs.zsh.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cifs-utils
    firefox
    ghostty
    google-chrome
    gnomeExtensions.arcmenu
    gnomeExtensions.blur-my-shell
    gnomeExtensions.caffeine
    gnomeExtensions.color-picker
    gnomeExtensions.dash-to-dock
    gnomeExtensions.dash-to-panel
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.notification-banner-reloaded
    gnomeExtensions.tray-icons-reloaded
    gnome-menus
    gnome-tweaks
    libreoffice
    neovim
    tmux
  ];
}

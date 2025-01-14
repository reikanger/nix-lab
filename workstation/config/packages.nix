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
    gnome-tweaks
    libreoffice
    neovim
    tmux
  ];
}

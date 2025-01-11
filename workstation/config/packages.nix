{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable ZSH
  programs.zsh.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cifs-utils
    firefox
    google-chrome
    gnome-tweaks
    libreoffice
    neovim
    ptyxis
    tmux
  ];
}

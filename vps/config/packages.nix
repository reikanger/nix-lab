{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cloudflared
    neovim
    tmux
  ];

  programs.zsh.enable = true;

  programs.fish.enable = true;
}

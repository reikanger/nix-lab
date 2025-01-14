{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.reika = {
    isNormalUser = true;
    description = "Ryan Eikanger";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "qemu" "kvm" "libvirtd" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK0ZmfCfV8PYxNvlDjYiMdwxlcu+ZC7xkjIBp3Qv6toA reika.io"
    ];
  };

  # Enable home-manager for the reika user
  home-manager.users.reika = import ./reika.home-manager;  
}

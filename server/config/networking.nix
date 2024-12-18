{ config, pkgs, ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "macragge"; # Define your hostname.

  # KVM bridge network interface

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 2049 111 ];
  networking.firewall.allowedUDPPorts = [ 2049 111 ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

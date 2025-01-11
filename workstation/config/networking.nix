{ config, pkgs, ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "protos"; # Define your hostname.

  # KVM bridge network interface

  # always allow traffic from the Tailscale network
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22          # ssh
  ];

  networking.firewall.allowedUDPPorts = [
    config.services.tailscale.port
  ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

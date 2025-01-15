{ config, pkgs, ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "vespator"; # Define your hostname

  # always allow traffic from the Tailscale network
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    80          # http
    443         # https
  ];

  networking.firewall.allowedUDPPorts = [
    config.services.tailscale.port
  ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

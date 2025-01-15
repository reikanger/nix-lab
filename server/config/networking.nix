{ config, pkgs, ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "macragge"; # Define your hostname.

  # KVM bridge network interface

  # always allow traffic from the Tailscale network
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22          # ssh
    80          # http
    443         # https
    111         # nfs
    2049        # nfs
    32400       # plex
  ];

  networking.firewall.allowedUDPPorts = [
    53		# dns
    111         # nfs
    2049        # nfs
    config.services.tailscale.port
  ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

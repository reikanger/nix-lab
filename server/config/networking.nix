{ config, pkgs, ... }:

{
  # Enable networking
  networking = {
    hostName = "macragge";  # Define your hostname
    domain = "lan";
    useDHCP = false;

    # Management network interface
    interfaces.enp0s25 = {
      ipv4.addresses = [{
        address = "192.168.1.5";
	prefixLength = 24;
      }];
    };

    # KVM bridge
    bridges = {
      "bridge0" = {
        interfaces = [ "enp5s0" ];
      };
    };

    # KVM bridge interface
    interfaces.bridge0 = {
      # unassigned address
    };

    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp0s25";
    };

    nameservers = [ "192.168.1.1" ];
  };

  # Disable NetworkManager
  networking.networkmanager.enable = false;

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

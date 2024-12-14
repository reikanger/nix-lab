# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # home-manager
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  # Enable networking
  networking.hostName = "macragge"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ZFS Support
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "801443fe";

  # Mount ZFS pool tank at boot
  boot.zfs.extraPools = [ "tank" ];

  # Automatic scrubbing of ZFS pools
  services.zfs.autoScrub.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.reika = {
    isNormalUser = true;
    description = "Ryan Eikanger";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK0ZmfCfV8PYxNvlDjYiMdwxlcu+ZC7xkjIBp3Qv6toA reika.io"
    ];
  };

  # Enable home-manager for the reika user
  home-manager.users.reika = import ./reika-home.nix;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    tmux
  ];

  programs.zsh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # NFS
  services.nfs.server = {
    enable = true;
    exports = ''
      /tank/documents *(rw,sync,no_subtree_check) 
      /tank/media *(rw,sync,no_subtree_check) 
      /tank/shared *(rw,sync,no_subtree_check) 
      /tank/software *(rw,sync,no_subtree_check) 
    ''; 
  };

  # Samba
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "invalid users" = [ "root" ];
        "passwd program" = "/run/wrappers/bin/passwd %u";
        security = "user";
	"socket options" = "TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=131072 SO_SNDBUF=131072";
	"aio read size" = "65536";
	"aio write size" = "65536";
	"read raw" = "yes";
	"write raw" = "yes";
      };
      documents = {
        browseable = "yes";
        comment = "JR Documents share";
        "guest ok" = "no";
        path = "/tank/documents";
        "read only" = "no";
      };
      media = {
        browseable = "yes";
        comment = "JR Media share";
        "guest ok" = "no";
        path = "/tank/media";
        "read only" = "no";
      };
      shared = {
        browseable = "yes";
        comment = "JR Public share";
        "guest ok" = "yes";
        path = "/tank/shared";
        "read only" = "no";
	"create mask" = "0666";
	"directory mask" = "0777";
	"force user" = "nobody";
        "force group" = "nogroup";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # ACME Lets Encrypt SSL Certificate
  security.acme = {
    acceptTerms = true;
    defaults.email = "ryan.eikanger@runbox.com";

    certs."reika.io" = {
      domain = "reika.io";
      extraDomainNames = [ "*.reika.io" ];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      credentialFiles = {
        "CLOUDFLARE_DNS_API_TOKEN_FILE" = "/root/cloudflare-api-token";
        "CLOUDFLARE_EMAIL_FILE" = "/root/cloudflare-email";
      };
      dnsPropagationCheck = true;
      reloadServices = [ "nginx" ];
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  # nginx reverse proxy
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."plex.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:32400/";
    };

    virtualHosts."transmission.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:39091/";
    };
  };

  # KVM service

  # KVM bridge network interface

  # podman service
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # podman containers
  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      plex = {
        image = "docker.io/plexinc/pms-docker:latest";
        hostname = "plex";
        ports = [
          "8181:8181/tcp"
          "32400:32400/tcp"
          "8324:8324/tcp"
          "32469:32469/tcp"
          "1900:1900/udp"
          "32410:32410/udp"
          "32412:32412/udp"
          "32413:32413/udp"
          "32414:32414/udp"
        ];
        environment = {
          PUID = "1000";
          PGID = "100";
          TZ = "America/Chicago";
          PLEX_CLAIM = "";
          ADVERTISE_IP = "http://192.168.1.5:32400/";
        };
        volumes = [
          "plex_data:/config"
          "plex_transcode:/transcode"
          "/tank/media/music/Albums:/mnt/music/albums:ro"
          "/tank/media/music/Ambient_Music:/mnt/music/ambient:ro"
          "/tank/media/music/Live:/mnt/music/live:ro"
          "/tank/media/music/Music_Videos:/mnt/music/musicvideos:ro"
          "/tank/media/music/Rap_Videos:/mnt/music/rapvideos:ro"
          "/tank/media/comedy:/mnt/videos/comedy:ro"
          "/tank/media/documentaries:/mnt/videos/documentaries:ro"
          "/tank/media/movies:/mnt/videos/movies:ro"
          "/tank/media/tv:/mnt/videos/tv:ro"
        ];
      };

      transmission = {
        image = "docker.io/haugene/transmission-openvpn:latest";
        hostname = "transmission";
        ports = [ "127.0.0.1:39091:9091" ];
        environment = {
          OPENVPN_PROVIDER = "PIA";
          OPENVPN_CONFIG = "netherlands";
          OPENVPN_USERNAME = "";
          OPENVPN_PASSWORD = "";
          WEBPROXY_ENABLED = "false";
          LOCAL_NETWORK = "192.168.1.0/24";
          PUID = "1000";
          PGID = "100";
          TZ = "America/Chicago";
          TRANSMISSION_RPC_AUTHENTICATION_REQUIRED = "true";
          TRANSMISSION_RPC_HOST_WHITELIST = "'127.0.0.1,192.168.1.*'";
          TRANSMISSION_RPC_USERNAME = "reika";
          TRANSMISSION_RPC_PASSWORD = "";
          TRANSMISSION_UMASK = "2";
        };
        volumes = [
          "/srv/podman/transmission:/data"
          "transmission_data:/config"
        ];
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=net_admin,mknod"
          "--device=/dev/net/tun"
        ];
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "no";
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 2049 111 ];
  networking.firewall.allowedUDPPorts = [ 2049 111 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}

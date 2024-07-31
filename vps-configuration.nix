# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "vespator"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # allow other for fuse mount (needed for sshfs mounts of audiobooks and podcasts)
  programs.fuse.userAllowOther = true;

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
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.reika = {
    isNormalUser = true;
    description = "Ryan Eikanger";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOj90mBV/k5D1z4Q3/EECpnqhSorG6dkHzBUfuJsLb12 reika@penguin"
    ];
  };

  # Automatic updates of packages
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  # Set the default editor to neovim
  environment.variables.EDITOR = "nvim";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cifs-utils
    git
    htop
    iftop
    iotop
    neovim
    sshfs
    tailscale
    tmux
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];
    extraConfig = ''
      set-option -g mouse on
      set-option -g default-shell ${pkgs.zsh}/bin/zsh
    '';
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "history" ];
      theme = "gentoo";
    };
  };

  # List services that you want to enable:
  fileSystems."/mnt/Music" = {
    device = "//100.71.204.20/Music";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"; 
    in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
  };

  # ACME LetsEncrypt
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

    virtualHosts."audiobooks.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:10081/";
      locations."/".proxyWebsockets = true;
    };

    #virtualHosts."bookstack.reika.io" = {
    #  forceSSL = true;
    #  useACMEHost = "reika.io";
    #  locations."/".proxyPass = "http://127.0.0.1:16875/";
    #};

    virtualHosts."rss.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:18080/";
    };

    virtualHosts."recipes.reika.io" = {
      addSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://localhost:10084/";
    };

    virtualHosts."monica.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:10085/";
    };

    virtualHosts."wallabag.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:19013/";
    };
  };

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

      # Audiobookshelf
      audiobooks = {
        image = "ghcr.io/advplyr/audiobookshelf:latest";
        hostname = "audiobooks";
        ports = [ "127.0.0.1:10081:80" ];
        environment = {
          AUDIOBOOKSHELF_UID = "1000";
          AUDIOBOOKSHELF_GID = "100";
        };
        volumes = [
          "/mnt/Music/Audiobooks:/mnt/audiobooks"
          "/mnt/Music/Podcasts:/mnt/podcasts"
          "audiobooks_config:/config"
          "audiobooks_metadata:/metadata"
        ];
      };

      # Bookstack
      #bookstack-app = {
      #  image = "lscr.io/linuxserver/bookstack";
      #  extraOptions = [ "--pod=bookstack" ];
      #  dependsOn = [ "bookstack-db" ];
      #  environment = {
      #    PUID = "1000";
      #    PGID = "100";
      #    TZ = "America/Chicago";
      #    APP_URL = "https://bookstack.reika.io";
      #    DB_HOST = "bookstack-db";
      #    DB_PORT = "3306";
      #    DB_USER = "bookstack";
      #    DB_PASS = "";
      #    DB_DATABASE = "bookstackapp";
      #  };
      #  volumes = [
      #    "bookstack_app_data:/config"
      #  ];
      #};

      #bookstack-db = {
      #  image = "docker.io/library/mariadb:latest";
      #  extraOptions = [ "--pod=bookstack" ];
      #  environment = {
      #    MARIADB_DATABASE = "bookstackapp";
      #    MARIADB_USER = "bookstack";
      #    MARIADB_PASSWORD = "";
      #    MARIADB_RANDOM_ROOT_PASSWORD = "yes";
      #  };
      #  volumes = [
      #    "bookstack_db_data:/config"
      #  ];
      #};

      # FreshRSS
      rss = {
        image = "lscr.io/linuxserver/freshrss:latest";
        hostname = "rss";
        ports = [ "127.0.0.1:18080:80" ];
        environment = {
          PUID = "1000";
          PGID = "100";
          TZ = "America/Chicago";
        };
        volumes = [
          "freshrss_data:/config"
        ];
      };

      # Mealie
      recipes = {
        image = "ghcr.io/mealie-recipes/mealie:latest";
        #hostname = "recipes";
        ports = [ "127.0.0.1:10084:9000" ];
        environment = {
          PUID = "1000";
          PGID = "100";
          TZ = "America/Chicago";
          MAX_WORKERS = "1";
          WEB_CONCURRENCY = "1";
          BASE_URL = "https://recipes.reika.io";
        };
        volumes = [
          "/srv/podman/mealie:/app/data"
        ];
      };

      # Monica
      monica-crm = {
        image = "docker.io/monica:latest";
        #hostname = "monica";
	extraOptions = [ "--pod=monica" ];
        dependsOn = [ "monica-db" ];
        #ports = [ "127.0.0.1:10085:80" ];
        environment = {
          APP_KEY = "";
          DB_HOST = "monica-db";
          DB_USERNAME = "";
          DB_PASSWORD = "";
          APP_TRUSTED_PROXIES = "*";
          APP_ENV = "production";
          APP_URL = "https://monica.reika.io/";
        };
        volumes = [
          "monica_data:/var/www/html/storage"
        ];
      };

      monica-db = {
        image = "docker.io/mysql:5.7";
        #hostname = "monica-db";
	extraOptions = [ "--pod=monica" ];
        environment = {
          MYSQL_RANDOM_ROOT_PASSWORD = "true";
          MYSQL_DATABASE = "monica";
          MYSQL_USER = "";
          MYSQL_PASSWORD = "";
        };
        volumes = [
          "monicadb_data:/var/lib/mysql"
        ];
      };

      # Wallabag
      walladb = {
        image = "docker.io/mariadb:latest";
        #hostname = "walladb";
	extraOptions = [ "--pod=walla" ];
        environment = {
          MYSQL_ROOT_PASSWORD = "";
        };
	volumes = [
	  "walladb_data:/var/lib/mysql"
	];
      };

      walla-redis = {
        image = "docker.io/redis:alpine";
	extraOptions = [ "--pod=walla" ];
      };

      wallabag = {
        image = "docker.io/wallabag/wallabag:latest";
        #hostname = "wallabag";
	extraOptions = [ "--pod=walla" ];
        dependsOn = [ "walladb" "walla-redis" ];
        #ports = [ "127.0.0.1:19013:80" ];
        environment = {
          MYSQL_ROOT_PASSWORD = "";
          SYMFONY__ENV__DATABASE_DRIVER = "pdo_mysql";
          SYMFONY__ENV__DATABASE_HOST = "walladb";
          SYMFONY__ENV__DATABASE_PORT = "3306";
          SYMFONY__ENV__DATABASE_NAME = "wallabag";
          SYMFONY__ENV__DATABASE_USER = "";
          SYMFONY__ENV__DATABASE_PASSWORD = "";
          SYMFONY__ENV__DATABASE_CHARSET = "utf8mb4";
	  SYMFONY__ENV__DATABASE_TABLE_PREFIX = "wallabag_";
          SYMFONY__ENV__DOMAIN_NAME = "https://wallabag.reika.io";
        };
        volumes = [
          "/srv/podman/wallabag/images:/var/www/wallabag/web/assets/images"
        ];
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.openFirewall = false; # don't want the 22 port exposed to all interfaces
  services.openssh.settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "no";
  };

  # Tailscale
  services.tailscale.enable = true;

  # create a oneshot job to authenticate to Tailscale
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey 
    '';
  };

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}


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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "macragge"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
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
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Force ZFS compatibility
  boot.kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;

  # ZFS Support
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "38704af3";

  # Mount Tank at boot
  boot.zfs.extraPools = [ "tank" ];

  # Automatic scrubbing of ZFS pools
  services.zfs.autoScrub.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.reika = {
    isNormalUser = true;
    description = "Ryan Eikanger";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOj90mBV/k5D1z4Q3/EECpnqhSorG6dkHzBUfuJsLb12 reika@penguin"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Automatic updates of packages
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  # Set the default editor to neovim
  environment.variables.EDITOR = "nvim";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    htop
    neovim
    tailscale
    tmux

    # bootcamp
    #chromedriver
    #python312
    #python312Packages.ipython
    #python312Packages.selenium
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
      plugins = [ "git" "history" "python" "man" ];
      theme = "gentoo";
    };
  };

  # List services that you want to enable:

  # Samba
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = smbnix
      netbios name = smbnix
      security = user 
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 100. 192.168.1. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      interfaces = lo enp0s25 tailscale0
      bind interfaces only = yes
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      Documents = {
        path = "/data/Documents";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "reika";
        "force group" = "users";
      };
      Inbox = {
        path = "/data/Inbox";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "reika";
        "force group" = "users";
      };
      Music = {
        path = "/data/Music";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "reika";
        "force group" = "users";
      };
      Photos = {
        path = "/data/Photos";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "reika";
        "force group" = "users";
      };
      Pictures = {
        path = "/data/Pictures";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "reika";
        "force group" = "users";
      };
      Public = {
        path = "/data/Public";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "reika";
        "force group" = "users";
      };
      Software = {
        path = "/data/Software";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "reika";
        "force group" = "users";
      };
      Videos = {
        path = "/data/Videos";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "reika";
        "force group" = "users";
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

    virtualHosts."books.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:18999/";
    };

    virtualHosts."cloudbeaver.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:28978/";
    };

    virtualHosts."cyberchef.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:18002/";
    };

    virtualHosts."firefly.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:58080/";
    };

    virtualHosts."homebox.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:7745/";
    };

    virtualHosts."jupyter.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:13888/";
      locations."/".proxyWebsockets = true;
    };

    virtualHosts."lidarr.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:18686/";
    };

    virtualHosts."lubelog.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:18089/";
    };

    virtualHosts."paperless.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:10083/";
    };

    virtualHosts."photos.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:32342/";
      locations."/".proxyWebsockets = true;
    };

    virtualHosts."plex.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:32400/";
    };

    virtualHosts."podgrab.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:18083/";
    };

    virtualHosts."pgadmin.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:45432/";
    };

    virtualHosts."prowlarr.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:19696/";
    };

    virtualHosts."radarr.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:17878/";
    };

    virtualHosts."rclone.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:25572/";
    };

    virtualHosts."readarr.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:18787/";
    };

    virtualHosts."scrutiny.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:18086/";
    };

    virtualHosts."sonarr.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:18989/";
    };

    virtualHosts."transmission.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:39091/";
    };

    virtualHosts."tubesync.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:14848/";
    };

    virtualHosts."uptime.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:43001/";
    };

    virtualHosts."yt.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:45033/";
      #locations."/".proxyWebsockets = true;
    };
  };

  # KVM service
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };

  # KVM bridge network interface
  virtualisation.libvirtd.allowedBridges = [ "bridge0" ];

  networking.interfaces."bridge0".useDHCP = true;

  networking.bridges = {
    "bridge0" = {
      interfaces = [ "enp0s25" ];
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
      books = {
        image = "docker.io/jvmilazz0/kavita:latest";
        hostname = "books";
        ports = [ "127.0.0.1:18999:5000" ];
        volumes = [
          "/data/Documents/Books:/manga:ro"
          "kavita_data:/kavita/config"
        ];
      };

      cloudbeaver = {
        image = "docker.io/dbeaver/cloudbeaver:latest";
        hostname = "cloudbeaver";
	environment = {
	  TZ = "America/Chicago";
	  CB_SERVER_URL = "https://cloudbeaver.reika.io";
	};
        ports = [ "127.0.0.1:28978:8978" ];
        volumes = [
	  "cloudbeaver_data:/opt/cloudbeaver/workspace"
	];
      };

      cyberchef = {
        image = "docker.io/mpepping/cyberchef:latest";
        hostname = "cyberchef";
        ports = [ "127.0.0.1:18002:8000" ];
      };

      firefly-app = {
        image = "fireflyiii/core:latest";
        extraOptions = [ "--pod=firefly" ];
        dependsOn = [ "firefly-db" ];
        environment = {
          APP_ENV = "production";
          APP_DEBUG = "false";
          SITE_OWNER = "reikanger@gmail.com";
          APP_KEY = "";
          DEFAULT_LANGUAGE = "en_US";
          DEFAULT_LOCALE = "equal";
          TZ = "America/Chicago";
          TRUSTED_PROXIES = "*";
          LOG_CHANNEL = "stack";
          APP_LOG_LEVEL = "notice";
          AUDIT_LOG_LEVEL = "emergency";
          DB_CONNECTION = "mysql";
          DB_HOST = "firefly-db";
          DB_PORT = "3306";
          DB_DATABASE = "firefly";
          DB_USERNAME = "firefly";
          DB_PASSWORD = "";
          MYSQL_USE_SSL = "false";
          MYSQL_SSL_VERIFY_SERVER_CERT = "true";
          MYSQL_SSL_CAPATH = "/etc/ssl/certs/";
          PGSQL_SSL_MODE = "prefer";
          PGSQL_SCHEMA = "public";
          CACHE_DRIVER = "file";
          SESSION_DRIVER = "file";
          REDIS_SCHEME = "tcp";
          REDIS_HOST = "127.0.0.1";
          REDIS_PORT = "6379";
          REDIS_DB = "0";
          REDIS_CACHE_DB = "1";
          COOKIE_PATH = "/";
          COOKIE_SECURE = "false";
          COOKIE_SAMESITE = "lax";
          MAIL_MAILER = "log";
          MAIL_PORT = "2525";
          MAIL_FROM = "changeme@example.com";
          MAILGUN_ENDPOINT = "api.mailgun.net";
          SEND_ERROR_MESSAGE = "true";
          SEND_REPORT_JOURNALS = "true";
          ENABLE_EXTERNAL_MAP = "false";
          ENABLE_EXCHANGE_RATES = "false";
          ENABLE_EXTERNAL_RATES = "false";
          MAP_DEFAULT_LAT = "51.983333";
          MAP_DEFAULT_LONG = "5.916667";
          MAP_DEFAULT_ZOOM = "6";
          VALID_URL_PROTOCOLS = "";
          AUTHENTICATION_GUARD = "web";
          AUTHENTICATION_GUARD_HEADER = "REMOTE_USER";
          DISABLE_FRAME_HEADER = "false";
          DISABLE_CSP_HEADER = "false";
          ALLOW_WEBHOOKS = "false";
          DKR_BUILD_LOCALE = "false";
          DKR_CHECK_SQLITE = "true";
          DKR_RUN_MIGRATION = "true";
          DKR_RUN_UPGRADE = "true";
          DKR_RUN_VERIFY = "true";
          DKR_RUN_REPORT = "true";
          DKR_RUN_PASSPORT_INSTALL = "true";
          APP_NAME = "FireflyIII";
          BROADCAST_DRIVER = "log";
          QUEUE_DRIVER = "sync";
          CACHE_PREFIX = "firefly";
          FIREFLY_III_LAYOUT = "v1";
          APP_URL = "https://firefly.reika.io";
        };
        volumes = [
          "firefly_upload:/var/www/html/storage/upload"
        ];
      };

      firefly-db = {
        image = "docker.io/mariadb:lts";
        extraOptions = [ "--pod=firefly" ];
        environment = {
          MYSQL_RANDOM_ROOT_PASSWORD = "yes";
          MYSQL_USER = "firefly";
          MYSQL_PASSWORD = "";
          MYSQL_DATABASE = "firefly";
        };
        volumes = [
          "firefly_db:/var/lib/mysql"
        ];
      };

#      firefly-cron = {
#        image = "docker.io/alpine";
#  extraOptions = [ "--pod=firefly" ];
#  cmd = [ "echo" "0" "3" "*" "*" "*" "wget" "-qO-" "http://firefly-app:8080/api/v1/cron/RHJczn2jxePRSygRpXtcRWpXqoj58fte" "|" "crontab" "-" "&&" "crond" "-f" "-L" "/dev/stdout" ];
#      };

      homebox = {
        image = "ghcr.io/sysadminsmedia/homebox:latest";
        hostname = "homebox";
        ports = [ "127.0.0.1:7745:7745" ];
        environment = {
          HBOX_LOG_LEVEL = "info";
          HBOX_LOG_FORMAT = "text";
          HBOX_WEB_MAX_UPLOAD_SIZE = "10";
        };
        volumes = [
          "homebox_data:/data"
        ];
      };

      jupyter = {
        image = "docker.io/jupyter/datascience-notebook:latest";
        hostname = "jupyter";
        cmd = [ "start-notebook.sh" "--NotebookApp.token=''" "--NotebookApp.password=''" ];
        ports = [ "127.0.0.1:13888:8888" ];
        environment = {
          JUPYTER_ENABLE_LAB = "yes";
          APP_UID = "1000";
          APP_GID = "100";
          NB_UID = "1000";
          NB_GID = "100";
          TZ = "America/Chicago";
        };
        volumes = [
          "/home/reika:/home/jovyan/work"
          "/etc/localtime:/etc/localtime:ro"
        ];
       };

      mongo = {
        image = "docker.io/mongodb/mongodb-community-server:latest";
	hostname = "mongo";
	ports = [ "27017:27017" ];
      };

      lidarr = {
        image = "lscr.io/linuxserver/lidarr:latest";
        hostname = "lidarr";
        ports = [ "127.0.0.1:18686:8686" ];
        environment = {
          PUID = "1000";
          PGID = "100";
          TZ = "America/Chicago";
        };
        volumes = [
          "lidarr_data:/config"
          "/srv/podman/lidarr:/downloads"
        ];
      };

      lubelog = {
        image = "ghcr.io/hargata/lubelogger:latest";
        hostname = "lubelog";
        ports = [ "127.0.0.1:18089:8080" ];
        environment = {
          MailConfig__EmailServer = "";
          MailConfig__EmailFrom = "";
          MailConfig__UseSSL = "false";
          MailConfig__Port = "587";
          MailConfig__Username = "";
          MailConfig__Password = "";
        };
        volumes = [
          "lubelog_data:/App"
          "keys:/root/.aspnet/DataProtection-Keys"
        ];
      };

      paperless = {
        image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
        hostname = "paperless";
        dependsOn = [ "paperless-broker" ];
        ports = [ "127.0.0.1:10083:8000" ];
        environment = {
          PAPERLESS_REDIS = "redis://paperless-broker:6379";
          PAPERLESS_URL = "https://paperless.reika.io";
        };
        volumes = [
          "/srv/podman/paperless/data:/usr/src/paperless/data"
          "/srv/podman/paperless/media:/usr/src/paperless/media"
        ];
      };

      paperless-broker = {
        image = "docker.io/library/redis:7";
        hostname = "paperless-broker";
        volumes = [
          "paperless_broker_data:/data"
        ];
      };

      photoprism = {
        image = "docker.io/photoprism/photoprism:latest";
        extraOptions = [ "--pod=photos" ];
        dependsOn = [ "photosdb" ];
        user = "1000:100";
        environment = {
          PHOTOPRISM_ADMIN_USER = "reika";
          PHOTOPRISM_ADMIN_PASSWORD = "";
          PHOTOPRISM_AUTH_MODE = "password";
          PHOTOPRISM_SITE_URL = "https://photos.reika.io/";
          PHOTOPRISM_DISABLE_TLS = "false";
          PHOTOPRISM_DEFAULT_TLS = "true";
          PHOTOPRISM_ORIGINALS_LIMIT = "5000";
          PHOTOPRISM_HTTP_COMPRESSION = "none";
          PHOTOPRISM_LOG_LEVEL = "info";
          PHOTOPRISM_READONLY = "false";
          PHOTOPRISM_EXPERIMENTAL = "false";
          PHOTOPRISM_DISABLE_CHOWN = "false";
          PHOTOPRISM_DISABLE_WEBDAV = "false";
          PHOTOPRISM_DISABLE_SETTINGS = "false";
          PHOTOPRISM_DISABLE_TENSORFLOW = "false";
          PHOTOPRISM_DISABLE_FACES = "false";
          PHOTOPRISM_DISABLE_CLASSIFICATION = "false";
          PHOTOPRISM_DISABLE_VECTORS = "false";
          PHOTOPRISM_DISABLE_RAW = "false";
          PHOTOPRISM_RAW_PRESETS = "false";
          PHOTOPRISM_JPEG_QUALITY = "90";
          PHOTOPRISM_DETECT_NSFW = "false";
          PHOTOPRISM_UPLOAD_NSFW = "true";
          PHOTOPRISM_DATABASE_DRIVER = "mysql";
          PHOTOPRISM_DATABASE_SERVER = "photosdb:3306";
          PHOTOPRISM_DATABASE_NAME = "photoprism";
          PHOTOPRISM_DATABASE_USER = "photoprism";
          PHOTOPRISM_DATABASE_PASSWORD = "";
          PHOTOPRISM_SITE_CAPTION = "AI-Powered Photos App";
          PHOTOPRISM_SITE_DESCRIPTION = "Reika PhotoPrism";
          PHOTOPRISM_SITE_AUTHOR = "Reika PhotoPrism";
        };
        workdir = "/photoprism";
        volumes = [
          "/srv/podman/photoprism/originals:/photoprism/originals"
          "/srv/podman/photoprism/import:/photoprism/import"
          "/srv/podman/photoprism/storage:/photoprism/storage"
        ];
      };

      photosdb = {
        image = "docker.io/mariadb:11";
        extraOptions = [ "--pod=photos" ];
        cmd = [
          "--innodb-buffer-pool-size=2G"
          "--transaction-isolation=READ-COMMITTED"
          "--character-set-server=utf8mb4"
          "--collation-server=utf8mb4_unicode_ci"
          "--max-connections=512"
          "--innodb-rollback-on-timeout=OFF"
          "--innodb-lock-wait-timeout=120"
        ];
        environment = {
          MARIADB_AUTO_UPGRADE = "1";
          MARIADB_INITDB_SKIP_TZINFO = "1";
          MARIADB_DATABASE = "photoprism";
          MARIADB_USER = "photoprism";
          MARIADB_PASSWORD = "";
          MARIADB_RANDOM_ROOT_PASSWORD = "yes";
        };
        volumes = [
          "photosdb_data:/var/lib/mysql"
        ];
      };

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
          "/data/Music/Albums:/mnt/music/albums:ro"
          "/data/Music/Ambient_Music:/mnt/music/ambient:ro"
          "/data/Music/Comedy:/mnt/music/comedy:ro"
          "/data/Music/Live:/mnt/music/live:ro"
          "/data/Music/Music_Videos:/mnt/music/musicvideos:ro"
          "/data/Music/Rap_Videos:/mnt/music/rapvideos:ro"
          "/data/Videos/Comedy:/mnt/videos/comedy:ro"
          "/data/Videos/Documentaries:/mnt/videos/documentaries:ro"
          "/data/Videos/Hockey:/mnt/videos/hockey:ro"
          "/data/Videos/Movies:/mnt/videos/movies:ro"
          "/data/Videos/TV:/mnt/videos/tv:ro"
          "/data/Videos/YouTube:/mnt/videos/youtube:ro"
        ];
      };

      podgrab = {
        image = "docker.io/akhilrex/podgrab:latest";
        hostname = "podgrab";
        ports = [ "127.0.0.1:18083:8080" ];
        environment = {
          CHECK_FREQUENCY = "240";
        };
        volumes = [
          "podgrab_data:/config"
          "/srv/podman/podgrab:/assets"
        ];
      };

      postgres = {
        image = "docker.io/postgres:latest";
	environment = {
	  POSTGRES_USER = "reika";
	  POSTGRES_PASSWORD = "";
	  PGDATA = "/var/lib/postgresql/data/pgdata";
	};
	ports = [
	  "5432:5432"
	];
	volumes = [
	  "postgres_data:/var/lib/postgresql/data"
	];
      };

      pgadmin = {
        image = "docker.io/dpage/pgadmin4:latest";
        environment = {
          PGADMIN_DEFAULT_EMAIL = "reikanger@gmail.com";
          PGADMIN_DEFAULT_PASSWORD = "";
	};
	ports = [
	  "45432:80"
	];
      };

      prowlarr = {
        image = "lscr.io/linuxserver/prowlarr:latest";
        hostname = "prowlarr";
        ports = [ "127.0.0.1:19696:9696" ];
        environment = {
          PUID = "1000";
          PGID = "100";
          TZ = "America/Chicago";
        };
        volumes = [
          "prowlarr_data:/config"
        ];
      };

      radarr = {
        image = "lscr.io/linuxserver/radarr:latest";
        hostname = "radarr";
        ports = [ "127.0.0.1:17878:7878" ];
        environment = {
                PUID = "1000";
                PGID = "100";
                TZ = "America/Chicago";
        };
        volumes = [
          "radarr_data:/config"
          "/srv/podman/radarr:/downloads"
        ];
      };

      rclone = {
        image = "docker.io/rclone/rclone:latest";
        hostname = "rclone";
        cmd = [ "rcd" "--rc-web-gui" "--rc-addr" ":5572" "--rc-user" "reika" "--rc-pass" "" ];
        ports = [ "127.0.0.1:25572:5572" ];
              user = "reika:users";
        volumes = [
          "rclone_data:/config/rclone"
          "/etc/passwd:/etc/passwd:ro"
          "/etc/group:/etc/group:ro"
        ];
      };

      readarr = {
        image = "lscr.io/linuxserver/readarr:develop";
        hostname = "readarr";
        ports = [ "127.0.0.1:18787:8787" ];
        environment = {
                PUID = "1000";
                PGID = "100";
                TZ = "America/Chicago";
        };
        volumes = [
          "readarr_data:/config"
          "/srv/podman/readarr:/downloads"
        ];
      };

      scrutiny = {
        image = "ghcr.io/analogj/scrutiny:master-omnibus";
	hostname = "scrutiny";
	ports = [ "127.0.0.1:18086:8080" ];
        extraOptions = [
          "--cap-add=SYS_RAWIO"
          "--device=/dev/sda"
          "--device=/dev/sdb"
          "--device=/dev/sdc"
          "--device=/dev/sdd"
          "--device=/dev/sde"
          "--device=/dev/sdf"
        ];
	volumes = [
	  "scrutiny_data:/opt/scrutiny"
	  "/run/udev:/run/udev:ro"
	];
      };

      sonarr = {
        image = "lscr.io/linuxserver/sonarr:latest";
        hostname = "sonarr";
        ports = [ "127.0.0.1:18989:8989" ];
        environment = {
                PUID = "1000";
                PGID = "100";
                TZ = "America/Chicago";
        };
        volumes = [
          "sonarr_data:/config"
          "/srv/podman/sonarr:/downloads"
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

      tubesync = {
        image = "ghcr.io/meeb/tubesync:latest";
        hostname = "tubesync";
        ports = [ "127.0.0.1:14848:4848" ];
        environment = {
          PUID = "1000";
          PGID = "100";
          TZ = "America/Chicago";
        };
        volumes = [
          "tubesync_data:/config"
          "/srv/podman/tubesync:/downloads"
        ];
      };

      uptime = {
        image = "docker.io/louislam/uptime-kuma:1";
        hostname = "uptime";
        ports = [ "127.0.0.1:43001:3001" ];
        volumes = [
          "uptime_data:/app/data"
        ];
        extraOptions = [ "--cap-add=NET_RAW" ];
      };

      youtubedl = {
        image = "docker.io/tzahi12345/youtubedl-material:latest";
        hostname = "yt";
        dependsOn = [ "ytdl-mongo-db" ];
        ports = [ "127.0.0.1:45033:17442" ];
        environment = {
          ytdl_mongodb_connection_string = "mongodb://ytdl-mongo-db:27017";
          ytdl_use_local_db = "false";
          write_ytdl_config = "true";
          UID = "1000";
          GID = "100";
        };
        volumes = [
          "/srv/podman/youtube/appdata:/app/appdata"
          "/srv/podman/youtube/audio:/app/audio"
          "/srv/podman/youtube/video:/app/video"
          "/srv/podman/youtube/subscriptions:/app/subscriptions"
          "/srv/podman/youtube/users:/app/users"
        ];
      };

      ytdl-mongo-db = {
        image = "docker.io/mongo:4";
        hostname = "ytdl-mongo-db";
        volumes = [
          "ytdl_data:/data/db"
        ];
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  networking.firewall.allowedTCPPorts = [ 22 80 443 5432 ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

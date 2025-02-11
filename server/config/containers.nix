{ config, pkgs, ... }:

{
  # podman service
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;

      # automatic update of podman images
      #autoUpdate.enable = true;
      #autoUpdate.schedule = "daily";
    };
  };

  # podman containers
  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      # ByteStash
      bytestash = {
        image = "ghcr.io/jordan-dalby/bytestash:latest";
	extraOptions = [ "--pull=newer" ];
	hostname = "bytestash";
	ports = [ "127.0.0.1:25025:5000" ];
	environment = {
	  # See https://github.com/jordan-dalby/ByteStash/wiki/FAQ#environment-variables
          BASE_PATH = "";
          JWT_SECRET = "";
          TOKEN_EXPIRY = "24h";
          ALLOW_NEW_ACCOUNTS = "true";
          DEBUG = "true";
          DISABLE_ACCOUNTS = "false";
          DISABLE_INTERNAL_ACCOUNTS = "false";

          # See https://github.com/jordan-dalby/ByteStash/wiki/Single-Sign%E2%80%90on-Setup for more info
          OIDC_ENABLED = "false";
          #OIDC_DISPLAY_NAME: ""
          #OIDC_ISSUER_URL: ""
          #OIDC_CLIENT_ID: ""
          #OIDC_CLIENT_SECRET: ""
          #OIDC_SCOPES: ""
	};
	volumes = [
	  "/srv/podman/bytestash:/data/snippets"
	];
      };

      cloudbeaver = {
        image = "docker.io/dbeaver/cloudbeaver:latest";
	extraOptions = [ "--pull=newer" ];
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
	extraOptions = [ "--pull=newer" ];
        hostname = "cyberchef";
        ports = [ "127.0.0.1:18002:8000" ];
      };

      firefly-app = {
        image = "fireflyiii/core:latest";
        extraOptions = [
	  "--pull=newer"
	  "--pod=firefly"
	];
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
          DB_DATABASE = "";
          DB_USERNAME = "";
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
        extraOptions = [
	  "--pull=newer"
	  "--pod=firefly"
	];
        environment = {
          MYSQL_RANDOM_ROOT_PASSWORD = "yes";
          MYSQL_USER = "";
          MYSQL_PASSWORD = "";
          MYSQL_DATABASE = "firefly";
        };
        volumes = [
          "firefly_db:/var/lib/mysql"
        ];
      };

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
	extraOptions = [ "--pull=newer" ];
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

      kavita = {
        image = "docker.io/jvmilazz0/kavita:latest";
	extraOptions = [ "--pull=newer" ];
        hostname = "kavita";
        ports = [ "127.0.0.1:18999:5000" ];
        volumes = [
          "/tank/media/books:/manga:ro"
          "kavita_data:/kavita/config"
        ];
      };

      lidarr = {
        image = "lscr.io/linuxserver/lidarr:latest";
	extraOptions = [ "--pull=newer" ];
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
	extraOptions = [ "--pull=newer" ];
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
	extraOptions = [ "--pull=newer" ]; # TODO: why not using a pod?
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
	extraOptions = [ "--pull=newer" ]; # TODO: why not using a pod?
        hostname = "paperless-broker";
        volumes = [
          "paperless_broker_data:/data"
        ];
      };

      pihole = {
        image = "docker.io/pihole/pihole:latest";
	# --pull=newer defined below
	hostname = "pihole";
	ports = [
	  "192.168.1.5:53:53/tcp"
	  "192.168.1.5:53:53/udp"
	  "127.0.0.1:10094:80/tcp"
	];
	environment = {
	  TZ = "America/Chicago";
	};
	volumes = [
	  "/srv/podman/pihole/pihole:/etc/pihole"
	  "/srv/podman/pihole/dnsmasq:/etc/dnsmasq.d"
	];
        extraOptions = [
	  "--pull=newer"
          #"--cap-add=NET_ADMIN" # only needed for DHCP service
	];
      };

      # Pinchflat
      pinchflat = {
        image = "ghcr.io/kieraneglin/pinchflat:latest";
	extraOptions = [ "--pull=newer" ];
	hostname = "pinchflat";
	ports = [ "127.0.0.1:18945:8945" ];
	environment = {
	  TZ = "America/Chicago";
	};
	volumes = [
	  "/srv/podman/pinchflat/config:/config"
	  "/srv/podman/pinchflat/downloads:/downloads"
	];
      };

      plex = {
        image = "docker.io/plexinc/pms-docker:latest";
	extraOptions = [ "--pull=newer" ];
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
          "/tank/media/sports:/mnt/videos/sports:ro"
          "/tank/media/tv:/mnt/videos/tv:ro"
        ];
      };

      podfetch = {
        image = "docker.io/samuel19982/podfetch:latest";
	extraOptions = [ "--pull=newer" ];
	hostname = "podfetch";
        ports = [ "127.0.0.1:18084:8000" ];
	environment = {
	  POLLING_INTERVAL = "60";
	  SERVER_URL = "https://podfetch.reika.io";
          DATABASE_URL = "sqlite:///app/db/podcast.db";
	};
	volumes = [
	  "podfetch_podcasts:/app/podcasts"
	  "podfetch_db:/app/db"
	];
      };

      prowlarr = {
        image = "lscr.io/linuxserver/prowlarr:latest";
	extraOptions = [ "--pull=newer" ];
        hostname = "prowlarr";
        ports = [ "127.0.0.1:19696:9696" ];
        environment = {
          PUID = "1000";
          PGID = "100";
          TZ = "America/Chicago";
        };
        volumes = [
          "prowlarr_data:/config"
	  "/srv/podman/prowlarr:/downloads"
        ];
      };

      radarr = {
        image = "lscr.io/linuxserver/radarr:latest";
	extraOptions = [ "--pull=newer" ];
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

      readarr = {
        image = "lscr.io/linuxserver/readarr:develop";
	extraOptions = [ "--pull=newer" ];
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
	# --pull=newer defined below
	hostname = "scrutiny";
	ports = [ "127.0.0.1:18086:8080" ];
        extraOptions = [
	  "--pull=newer"
          "--cap-add=SYS_RAWIO"
          "--device=/dev/nvme0n1"
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
	extraOptions = [ "--pull=newer" ];
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
	# --pull=newer defined below
        hostname = "transmission";
        ports = [ "127.0.0.1:39091:9091" ];
        environment = {
          OPENVPN_PROVIDER = "";
          OPENVPN_CONFIG = "";
          OPENVPN_USERNAME = "";
          OPENVPN_PASSWORD = "";
          WEBPROXY_ENABLED = "false";
          LOCAL_NETWORK = "192.168.1.0/24";
          PUID = "1000";
          PGID = "100";
          TZ = "America/Chicago";
          TRANSMISSION_RPC_AUTHENTICATION_REQUIRED = "true";
          TRANSMISSION_RPC_HOST_WHITELIST = "'127.0.0.1,192.168.1.*'";
          TRANSMISSION_RPC_USERNAME = "";
          TRANSMISSION_RPC_PASSWORD = "";
          TRANSMISSION_UMASK = "2";
        };
        volumes = [
          "/srv/podman/transmission:/data"
          "transmission_data:/config"
        ];
        extraOptions = [
	  "--pull=newer"
          "--cap-add=NET_ADMIN"
          "--cap-add=net_admin,mknod"
          "--device=/dev/net/tun"
        ];
      };

      # Uptime Kuma - https://github.com/louislam/uptime-kuma
      uptime = {
        image = "docker.io/louislam/uptime-kuma:1";
	extraOptions = [ "--pull=newer" ];
	hostname = "uptime";
        ports = [ "127.0.0.1:23001:3001" ];
        volumes = [
          "uptime_data:/app/data"
        ];
      };
    };
  };
}

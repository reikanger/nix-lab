{ config, pkgs, ... }:

{
  # Podman service
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
	extraOptions = [ "--pull=newer" ];
        hostname = "audiobooks";
        ports = [ "127.0.0.1:10081:80" ];
        environment = {
          AUDIOBOOKSHELF_UID = "1000";
          AUDIOBOOKSHELF_GID = "100";
        };
        volumes = [
          "audiobooks_config:/config"
          "audiobooks_metadata:/metadata"
        ];
      };

      # Mealie
      recipes = {
        image = "ghcr.io/mealie-recipes/mealie:latest";
	extraOptions = [ "--pull=newer" ];
        hostname = "recipes";
	#user = "1000:100";
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

      # Wallabag
      walladb = {
        image = "docker.io/mariadb:latest";
	extraOptions = [ "--pod=walla" "--pull=newer" ];
        environment = {
          MYSQL_ROOT_PASSWORD = "";
        };
	volumes = [
	  "walladb_data:/var/lib/mysql"
	];
      };

      walla-redis = {
        image = "docker.io/redis:alpine";
	extraOptions = [ "--pod=walla" "--pull=newer" ];
      };

      wallabag = {
        image = "docker.io/wallabag/wallabag:latest";
	extraOptions = [ "--pod=walla" "--pull=newer" ];
        dependsOn = [ "walladb" "walla-redis" ];
        #ports = [ "127.0.0.1:19013:80" ];
        environment = {
          MYSQL_ROOT_PASSWORD = "";
          SYMFONY__ENV__DATABASE_DRIVER = "pdo_mysql";
          SYMFONY__ENV__DATABASE_HOST = "walladb";
          SYMFONY__ENV__DATABASE_PORT = "3306";
          SYMFONY__ENV__DATABASE_NAME = "";
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
}

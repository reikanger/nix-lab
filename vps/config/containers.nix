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
          "/mnt/media/audiobooks:/audiobooks"
          "/mnt/media/podcasts:/podcasts"
        ];
      };

      # Glance
      glance = {
        image = "docker.io/glanceapp/glance:latest";
	extraOptions = [ "--pull=newer" ];
	hostname = "glance";
	ports = [ "127.0.0.1:10091:8080" ];
	volumes = [
	  "/srv/podman/glance/glance.yml:/app/glance.yml"
	  "/etc/localtime:/etc/localtime:ro"
	];
      };

      # GPodder Sync - https://hub.docker.com/r/ganeshlab/opodsync
      gpodder = {
        image = "docker.io/ganeshlab/opodsync:latest";
	extraOptions = [ "--pull=newer" ];
	hostname = "gpodder";
	ports = [ "127.0.0.1:10092:8080" ];
	volumes = [
	  "gpodder_data:/var/www/server/data"
	];
      };

      # Hoader
      hoarder-web = {
	image = "ghcr.io/hoarder-app/hoarder:release";
	extraOptions = [ "--pod=hoarder" "--pull=newer" ];
        dependsOn = [ "hoarder-chrome" "hoarder-search" ];
	environment = {
	  HOARDER_VERSION = "release";
          NEXTAUTH_SECRET = "";
          MEILI_MASTER_KEY = "";
          NEXTAUTH_URL = "https://hoarder.reika.io";
	  MEILI_ADDR = "http://hoarder-search:7700";
	  BROWSER_WEB_URL = "http://hoarder-chrome:9222";
	  DATA_DIR = "/data";
	  DISABLE_SIGNUPS = "true";
	};
	volumes = [
	  "hoarder_data:/data"
	];
      };

      hoarder-chrome = {
        image = "gcr.io/zenika-hub/alpine-chrome:123";
	extraOptions = [ "--pod=hoarder" "--pull=newer" ];
	cmd = [
	  "--no-sandbox"
	  "--disable-gpu"
	  "--disable-dev-shm-usage"
	  "--remote-debugging-address=0.0.0.0"
	  "--remote-debugging-port=9222"
	  "--hide-scrollbars"
	];
      };

      hoarder-search = {
        image = "docker.io/getmeili/meilisearch:v1.11.1";
	extraOptions = [ "--pod=hoarder" "--pull=newer" ];
	environment = {
	  HOARDER_VERSION = "release";
          NEXTAUTH_SECRET = "";
          MEILI_MASTER_KEY = "";
          NEXTAUTH_URL = "https://hoarder.reika.io";
	  MEILI_NO_ANALYTICS = "true";
	};
	volumes = [
	  "hoarder_search_data:/meili_data"
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
    };
  };
}

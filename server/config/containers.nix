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
          TRANSMISSION_RPC_USERNAME = "";
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
}

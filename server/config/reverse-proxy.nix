{ config, pkgs, ... }:

{
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
}

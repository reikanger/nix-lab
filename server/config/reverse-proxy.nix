{ config, pkgs, ... }:

{
  # nginx reverse proxy
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."cloudbeaver.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:28978/";
    };

    virtualHosts."bytestash.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:25025/";
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

    virtualHosts."kavita.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:18999/";
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

    virtualHosts."pihole.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:10094/";
    };

    virtualHosts."pinchflat.reika.io" = {
      forceSSL = true;
      useACMEHost = "reika.io";
      locations."/".proxyPass = "http://127.0.0.1:18945/";
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
  };
}

{ config, pkgs, ... }:

{
  systemd.services.podman-create-pod-hoarder = {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "podman-hoader-search.service" "podman-hoader-chrome.service" "podman-hoarder-web.service" ];
    script = ''
      ${pkgs.podman}/bin/podman pod exists hoarder || \
        ${pkgs.podman}/bin/podman pod create --name hoarder -p '127.0.0.1:19025:3000'
    '';
  };  
}

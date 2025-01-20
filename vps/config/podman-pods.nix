{ config, pkgs, ... }:

{
  systemd.services.podman-create-pod-walla = {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "podman-walladb.service" ];
    script = ''
      ${pkgs.podman}/bin/podman pod exists walla || \
        ${pkgs.podman}/bin/podman pod create --name walla -p '127.0.0.1:19013:80'
    '';
  };  
}

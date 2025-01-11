{ config, pkgs, ... }:

{
  systemd.services.podman-create-pod-firefly = {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "podman-firefly-db.service" ];
    script = ''
      ${pkgs.podman}/bin/podman pod exists firefly || \
        ${pkgs.podman}/bin/podman pod create --name firefly -p '127.0.0.1:58080:8080'
    '';
  };  
}

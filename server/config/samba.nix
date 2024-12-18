{ config, pkgs, ... }:

{
  # Samba
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "invalid users" = [ "root" ];
        "passwd program" = "/run/wrappers/bin/passwd %u";
        security = "user";
        "socket options" = "TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=131072 SO_SNDBUF=131072";
        "aio read size" = "65536";
        "aio write size" = "65536";
        "read raw" = "yes";
        "write raw" = "yes";
      };
      documents = {
        browseable = "yes";
        comment = "JR Documents share";
        "guest ok" = "no";
        path = "/tank/documents";
        "read only" = "no";
      };
      media = {
        browseable = "yes";
        comment = "JR Media share";
        "guest ok" = "no";
        path = "/tank/media";
        "read only" = "no";
      };
      shared = {
        browseable = "yes";
        comment = "JR Public share";
        "guest ok" = "yes";
        path = "/tank/shared";
        "read only" = "no";
        "create mask" = "0666";
        "directory mask" = "0777";
        "force user" = "nobody";
        "force group" = "nogroup";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}

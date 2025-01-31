{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ nfs-utils ];

  boot.initrd = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };

  fileSystems."/mnt/media" = {
    device = "macragge.walleye-walleye.ts.net:/tank/media";
    fsType = "nfs4";
  };
}

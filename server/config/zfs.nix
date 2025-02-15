{ config, pkgs, ... }:

{
  # ZFS Support
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "801443fe";

  # Mount ZFS pool tank at boot
  boot.zfs.extraPools = [ "tank" ];

  # Automatic scrubbing of ZFS pools
  services.zfs.autoScrub.enable = true;

  # Automatic snapshots
  services.zfs.autoSnapshot.enable = true;
}

# NFS option 'crossmnt', seemingly needed to share subdirectories on ZFS hosted file paths
# https://discourse.nixos.org/t/solved-weird-nfs-exports-problem/43297

{ config, pkgs, ... }:

{
  # NFS
  services.nfs.server = {
    enable = true;
    exports = ''
      /tank/documents  192.168.1.0/24(rw,sync,nohide,no_subtree_check,crossmnt) 100.0.0.0/8(ro,sync,nohide,no_subtree_check,crossmnt)
      /tank/media      192.168.1.0/24(rw,sync,nohide,no_subtree_check,crossmnt) 100.0.0.0/8(ro,sync,nohide,no_subtree_check,crossmnt)
      /tank/shared     192.168.1.0/24(rw,sync,nohide,no_subtree_check,crossmnt) 100.0.0.0/8(ro,sync,nohide,no_subtree_check,crossmnt)
      /tank/software   192.168.1.0/24(rw,sync,nohide,no_subtree_check,crossmnt) 100.0.0.0/8(ro,sync,nohide,no_subtree_check,crossmnt)
    ''; 
  };
}

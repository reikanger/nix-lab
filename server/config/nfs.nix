{ config, pkgs, ... }:

{
  # NFS
  services.nfs.server = {
    enable = true;
    exports = ''
      /tank/documents *(rw,sync,no_subtree_check) 
      /tank/media *(rw,sync,no_subtree_check) 
      /tank/shared *(rw,sync,no_subtree_check) 
      /tank/software *(rw,sync,no_subtree_check) 
    ''; 
  };
}

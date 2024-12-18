{ config, pkgs, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "no";
  };
}

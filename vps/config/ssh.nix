{ config, pkgs, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Don't automatically open the ssh port
  services.openssh.openFirewall = true;

  services.openssh.settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "no";
  };
}

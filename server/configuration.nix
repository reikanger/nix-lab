# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # home-manager
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  # Enable networking
  networking.hostName = "macragge"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ZFS Support
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "801443fe";

  # Mount ZFS pool tank at boot
  boot.zfs.extraPools = [ "tank" ];

  # Automatic scrubbing of ZFS pools
  services.zfs.autoScrub.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.reika = {
    isNormalUser = true;
    description = "Ryan Eikanger";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK0ZmfCfV8PYxNvlDjYiMdwxlcu+ZC7xkjIBp3Qv6toA reika.io"
    ];
  };

  # Enable home-manager for the reika user
  home-manager.users.reika = import ./reika-home.nix;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    tmux
  ];

  programs.zsh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Samba
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "invalid users" = [ "root" ];
        "passwd program" = "/run/wrappers/bin/passwd %u";
        security = "user";
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
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # ACME Lets Encrypt SSL Certificate

  # nginx reverse proxy

  # KVM service

  # KVM bridge network interface

  # podman service

  # podman containers

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "no";
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPorts = [  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}

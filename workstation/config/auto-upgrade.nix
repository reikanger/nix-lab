{ config, pkgs, ... }:

{
  # Automatic updates of packages                                                                                                                                                              
  system.autoUpgrade.enable = true;                                                                                                                                                            
  system.autoUpgrade.allowReboot = false;
}

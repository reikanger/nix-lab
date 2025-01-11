{ config, pkgs, ... }:

{
  # Steam                                                                                                                                                                                     
  programs.steam = {                                                                                                                                                                           
    enable = true;                                                                                                                                                                             
  };                                                                                                                                                                                           
                                                                                                                                                                                               
  # Gamemode                                                                                                                                                                                   
  programs.gamemode = {                                                                                                                                                                        
    enable = true;                                                                                                                                                                             
    enableRenice = true;                                                                                                                                                                       
    settings = {                                                                                                                                                                               
      general = {                                                                                                                                                                              
        desiredgov = "performance";                                                                                                                                                            
        softrealtime = "auto";                                                                                                                                                                 
        renice = 10;                                                                                                                                                                           
      };                                                                                                                                                                                       
      custom = {                                                                                                                                                                               
        start = "/run/current-system/sw/bin/gnome-extensions enable dash-to-panel@jderose9.github.com";                                                                                        
        end = "/run/current-system/sw/bin/gnome-extensions disable dash-to-panel@jderose9.github.com";                                                                                         
      };                                                                                                                                                                                       
    };                                                                                                                                                                                         
  };
}

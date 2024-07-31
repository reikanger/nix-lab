{ config, pkgs, ... }:

{
  home.username = "reika";
  home.homeDirectory = "/home/reika";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    htop
    iftop
    iotop
    tree
  ];

  programs.git = {
    enable = true;
    userName = "Ryan Eikanger";
    userEmail = "reikanger@gmail.com";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      set background=light
      set nu
    '';
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];
    extraConfig = ''
      set-option -g mouse on
      set-option -g default-shell ${pkgs.zsh}/bin/zsh
    '';
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      vi = "nvim";
      vim = "nvim";
      pipupgrade = "pip freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs pip install -U";
      pip3upgrade = "pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs pip3 install -U";
      macragge = "ssh -A reika@macragge.lan";
      macragge-ts = "ssh -A reika@macragge.walleye-walleye.ts.net";
      protos = "ssh -A reika@protos.lan";
      protos-ts = "ssh -A reika@protos.walleye-walleye.ts.net";
      vespator = "ssh -A reika@vespator.walleye-walleye.ts.net";
    };
  };
}

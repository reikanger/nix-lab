{ config, pkgs, ... }:

{
  home.username = "reika";
  home.homeDirectory = "/home/reika";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Git Configuration
  programs.git = {
    enable = true;
    userName = "Ryan Eikanger";
    userEmail = "reikanger@gmail.com";
  };

  # tmux configuration
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

  # Shell Configuration
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    #zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "history" "python" "man" ];
      theme = "gentoo";
    };

    shellAliases = {
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      vi = "nvim";
      vim = "nvim";
      pipupgrade = "pip freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs pip install -U";
      pip3upgrade = "pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs pip3 install -U";
      run-vlc = "NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#vlc";
      run-vscode = "NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#vscode";
      macragge = "ssh -A reika@macragge.lan";
      macragge-ts = "ssh -A reika@macragge.walleye-walleye.ts.net";
      protos = "ssh -A reika@protos.lan";
      protos-ts = "ssh -A reika@protos.walleye-walleye.ts.net";
      vespator = "ssh -A reika@vespator.walleye-walleye.ts.net";
    };
  };

  # Packages installed to the user profile
  home.packages = with pkgs; [
    # utils
    git
    htop
    iftop
    iotop
    tmux
  ];
}
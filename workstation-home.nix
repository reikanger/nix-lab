{ config, pkgs, ... }:

{
  home.username = "reika";
  home.homeDirectory = "/home/reika";

  home.packages = with pkgs; [
    # applications
    bitwarden
    bottles
    discord
    drawio
    git
    gnome.gnome-boxes
    #libation
    neovim
    obsidian  # broken hash mismatch on last build
    parabolic
    planify
    plexamp
    postman
    slack
    video-trimmer
    virt-manager
    zoom-us

    # data science
    dbeaver-bin
    mongodb-compass
    mongosh
    mongodb-tools
    #chromedriver
    #google-chrome
    #python312
    #python312Packages.ipython
    #python312Packages.selenium
    #python312Packages.beautifulsoup4
    #python312Packages.jupyterlab
    #python312Packages.ipykernel
    #python312Packages.splinter

    # large language model - https://ollama.com/
    ollama

    # gaming
    cartridges
    #lutris

    # gnome extensions
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.gemini-ai
    gnomeExtensions.night-theme-switcher

    # utils
    curl
    doctl
    file
    gcc
    gnumake
    htop
    iftop
    iotop
    jq
    ripgrep
    tmux
    tree

    # archives
    zip
    xz
    unzip
    p7zip
  ];

  programs.git = {
    enable = true;
    userName = "Ryan Eikanger";
    userEmail = "reikanger@gmail.com";
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
      run-vlc = "NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#vlc";
      run-vscode = "NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#vscode";
      macragge = "ssh -A reika@macragge.lan";
      macragge-ts = "ssh -A reika@macragge.walleye-walleye.ts.net";
      protos = "ssh -A reika@protos.lan";
      protos-ts = "ssh -A reika@protos.walleye-walleye.ts.net";
      vespator = "ssh -A reika@vespator.walleye-walleye.ts.net";
    };
  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}

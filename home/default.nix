{ pkgs, pkgs-stable, configData, gitalias, isPersonal, ... }:

{
  imports = [
    ./sway
    ./foot
    ./mpv
    ./waybar
    ./nwg-bar
    ./fuzzel
    ./nushell
  ];

  home = {
    username = "${configData.username}";
    homeDirectory = "/home/${configData.username}";

    pointerCursor = {
      name = "Yaru";
      package = pkgs.yaru-theme;
      size = 24;
      gtk.enable = true;
    };

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.11";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  gtk = {
    enable = true;
    font = {
      name = configData.homeSettings.fonts.latin.ui;
      size = 12;
    };
    iconTheme = {
      name = "Papirus-Dark";
    };
    theme = {
      name = "Yaru-dark";
      package = pkgs.yaru-theme;
    };
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=KvArcDark";
  };

  programs.git = {
    enable = true;
    userName = "Thammachart";
    userEmail = "1731496+Thammachart@users.noreply.github.com";

    includes = [
      { path = "${gitalias}/gitalias.txt"; }
    ];
  };
  
  programs.aria2 = {
    enable = isPersonal;
    settings = {
      allow-overwrite = true;
      # log = "-";
      console-log-level = "notice";
      # file-allocation = "falloc";
      
      # summary-interval = 120;

      enable-rpc = true;
      rpc-secure = false;
      rpc-listen-all = false;
      rpc-listen-port = 6802;
      rpc-allow-origin-all = true;
      
      max-concurrent-downloads = 2;
      max-connection-per-server = 1;
      
      dir = "/data/sda1/Times/High";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

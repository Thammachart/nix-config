{ pkgs, pkgs-stable, configData, gitalias, ... }:

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
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 24;
      x11 = {
        enable = true;
        defaultCursor = "Adwaita";
      };
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

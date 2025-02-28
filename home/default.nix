{ pkgs, lib, config, configData, conditions, gitalias, ... }:

{
  imports = [
    ./hypr
    ./sd
    ./foot
    ./ghostty
    ./firefox.nix
    ./mako
    ./sway
    # ./river
    ./mpv
    ./waybar
    ./nwg-bar
    ./fuzzel
    ./nushell
    ./go
  ];

  home = {
    username = "${configData.username}";
    homeDirectory = "/home/${configData.username}";

    pointerCursor = lib.mkIf conditions.graphicalUser {
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
    stateVersion = "24.11";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  gtk = {
    enable = conditions.graphicalUser;
    font = {
      name = configData.homeSettings.fonts.latin.ui;
      size = 12;
    };
    iconTheme = {
      name = "Papirus-Dark";
    };
    theme = {
      name = "Yaru-prussiangreen-dark";
      package = pkgs.yaru-theme;
    };
  };

  # xdg.configFile = lib.mkIf conditions.graphicalUser {
  #   "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=KvArcDark";
  # };

  programs.git = {
    enable = true;
    userName = "Thammachart";
    userEmail = "1731496+Thammachart@users.noreply.github.com";

    signing.format = "ssh";
    extraConfig = {
      merge = {
        log = 100;
      };
      init = {
        defaultBranch = "main";
      };
    };

    includes = [
      { path = "${gitalias}/gitalias.txt"; }
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

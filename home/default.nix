{ pkgs, lib, config, configData, conditions, gitalias, ... }:

{
  imports = [
    ./gpg.nix
    ./hypr
    ./sd
    ./foot
    ./ghostty
    ./firefox.nix
    ./mako
    ./sway
    ./niri
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
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 28;
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
    stateVersion = "25.05";
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

    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519_sk.pub";
    };

    settings = {
      user.name = "Thammachart";
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

  # home.sessionVariables doesn't load with nushell
  systemd.user.sessionVariables = lib.mkMerge [
    config.home.sessionVariables
    {}
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

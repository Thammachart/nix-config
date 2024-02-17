{ pkgs, pkgs-unstable, ... }:

let
  config = import ./config.nix;
in
{
  imports = [
    ./sway
    ./foot
    ./mpv
    ./waybar
    ./nwg-bar
    ./fuzzel
  ];

  home = {
    username = "${config.username}";
    homeDirectory = "/home/${config.username}";


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
      name = config.homeSettings.fonts.latin.ui;
      size = 12;
    };
    iconTheme = {
      name = "Papirus-Dark";
    };
    theme = {
      name = "Yaru-dark";
    };
  };

  qt = {
    enable = true;

    platformTheme = "qtct";
    style.name = "kvantum";
  };

  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscodium;
  };

  programs.nushell = {
  };

  programs.git = {
    enable = true;
    userName = "Thammachart";
    userEmail = "1731496+Thammachart@users.noreply.github.com";

    includes = [
      { path = "~/gitalias.txt"; }
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

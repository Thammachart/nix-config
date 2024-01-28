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

  gtk = {
    enable = true;
    font = {
      name = "Ubuntu";
      size = 12;
    };
    iconTheme.name = "Papirus-Dark";
    theme = {
      name = "Catppuccin-Macchiato-Compact-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "macchiato";
      };
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

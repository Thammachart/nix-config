{ config, inputs, lib, pkgs, configData, hostConfig, conditions , hostName, nix-secrets, betterfox, ... }:
let
  foot-with-patches = import ../packages/foot { inherit pkgs; };
  vscodium-with-patches = import ../packages/vscodium { inherit pkgs configData; };
  chromiumPasswordStore = "--password-store=${if config.secret-providers.kwallet.enable then "kwallet6" else "gnome-libsecret"}";
in
{
  imports = [
    ./secrets.nix
    ./overlays.nix
    ./network.nix
    ./systemd.nix
    ./fonts.nix
    ./display-manager.nix
    ./desktop-sessions/sway.nix
    ./desktop-sessions/hyprland.nix
    ./desktop-sessions/niri.nix
    ./secret-providers/gnome-keyring.nix
    ./secret-providers/kwallet.nix
    ./secret-providers/oo7-daemon.nix
  ];

  security.rtkit.enable = conditions.graphicalUser;
  services.pipewire = {
    enable = conditions.graphicalUser;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth = {
    enable = lib.mkDefault conditions.graphicalUser;
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "dual";
        PairableTimeout = 120;
      };
    };
  };

  services.blueman = {
    enable = lib.mkDefault conditions.graphicalUser;
  };


  environment.systemPackages = with pkgs; [] ++ lib.optionals conditions.graphicalUser [
    foot-with-patches
    # neohtop
    xdg-utils
    # firefox
    # floorp-bin
    # librewolf
    # qutebrowser
    (brave.override { commandLineArgs = [ chromiumPasswordStore ]; })
    pavucontrol
    libnotify
    vulkan-tools
    wev
    flameshot

    obsidian
    logseq

    (vscodium-with-patches.override { commandLineArgs = [ chromiumPasswordStore ]; }).fhs
    geany
    zed-editor
    gnome-text-editor

    glib

    papirus-icon-theme
    yaru-theme

    syncthing
    waybar
    wlsunset

    wl-clipboard

    fuzzel
    mako
    wlr-randr wlopm shikane
    # nwg-displays
    nwg-bar
    keepassxc
    seahorse

    nautilus

    # lxqt.pcmanfm-qt
    # lxqt.lximage-qt
    # lxqt.lxqt-archiver
    # lxqt.qps

    qalculate-gtk
    imv
    qview
    mpv
    # clapper

    # PDF Viewer
    papers
    foliate

    libsForQt5.qt5.qtwayland
    # libsForQt5.qt5ct

    kdePackages.qtwayland
    kdePackages.qtsvg
    kdePackages.qt6ct
    kdePackages.qtstyleplugin-kvantum

    kdePackages.ark
    # kdePackages.kcoreaddons
    # kdePackages.frameworkintegration
    # kdePackages.plasma-workspace
    # kdePackages.kde-cli-tools
    # kdePackages.breeze

    # kdePackages.kirigami
    # kdePackages.kirigami-addons
    # kdePackages.kservice
    # kdePackages.dolphin
    # kdePackages.dolphin-plugins
    # kdePackages.libplasma
    # kdePackages.kfilemetadata
    # kdePackages.kimageformats
    # kdePackages.kio # provides helper service + a bunch of other stuff
    # kdePackages.kio-admin # managing files as admin
    # kdePackages.kio-extras # stuff for MTP, AFC, etc
    # kdePackages.kio-fuse
    # kdePackages.kquickcharts
    # kdePackages.plasma-systemmonitor
    # kdePackages.ksystemstats
    # kdePackages.libksysguard
    # kdePackages.kate
    # kdePackages.okular

    xorg.xprop
    libva-utils
    waypaper
    glxinfo
    pinta

    yubikey-manager

    bustle
  ];

  # Workaround for Dolphin MIME
  # environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  qt = {
    enable = lib.mkDefault conditions.graphicalUser;
  };

  services.pcscd = {
    enable = false;
  };

  services.gvfs = {
    enable = lib.mkDefault conditions.graphicalUser;
    package = pkgs.gvfs;
  };

  services.fwupd = {
    enable = conditions.isLaptop;
  };

  xdg.portal = {
    enable = lib.mkDefault conditions.graphicalUser;
    xdgOpenUsePortal = false;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common = { default = [ "gtk" ]; };
    };
  };

  programs.kdeconnect = {
    enable = false;
    package = pkgs.kdePackages.kdeconnect-kde;
  };

  # secret-providers.gnome-keyring.enable = lib.mkDefault conditions.graphicalUser;
  secret-providers.kwallet.enable = lib.mkDefault conditions.graphicalUser;
  # secret-providers.oo7-daemon.enable = lib.mkDefault conditions.graphicalUser;

  programs.gnome-disks = {
    enable = lib.mkDefault conditions.graphicalUser;
  };

  programs.evince = {
    enable = false;
  };

  programs.dconf = {
    enable = lib.mkDefault conditions.graphicalUser;
    profiles = {
      user.databases = [
        {
          settings = with lib.gvariant; {
            "org/gnome/desktop/privacy" = {
              recent-files-max-age = mkInt32 0;
              remember-recent-files  = mkBoolean false;
              remove-old-trash-files = mkBoolean true;
              old-files-age = mkUint32 14;
            };
            "org/gnome/desktop/interface" = {
              color-scheme = mkString "prefer-dark";
            };
            "org/gnome/nm-applet" = {
              disable-connected-notifications = mkBoolean true;
            };
          };
        }
      ];
    };
  };

  desktop-sessions.sway.enable = lib.mkDefault conditions.graphicalUser;
  desktop-sessions.hyprland.enable = lib.mkDefault conditions.hyprland;
  desktop-sessions.niri.enable = lib.mkDefault conditions.niri;

  # programs.sway = {
  #   enable = lib.mkDefault conditions.graphicalUser;
  #   package = pkgs.sway;
  #   wrapperFeatures.gtk = true;
  #   extraPackages = with pkgs; [ grim slurp swaylock swayidle swaybg ];
  # };

  # programs.river = {
  #   enable = false;
  #   xwayland.enable = true;
  #   extraPackages = with pkgs; [];
  # };

  # programs.hyprland = {
  #   enable = lib.mkDefault conditions.graphicalUser;
  #   xwayland.enable = true;
  # };

  # programs.hyprlock = {
  #   enable = config.programs.hyprland.enable;
  # };

  # services.hypridle = {
  #   enable = config.programs.hyprland.enable;
  # };

  programs.xwayland = {
    enable = lib.mkDefault conditions.graphicalUser;
  };

  programs.thunderbird = {
    enable = lib.mkDefault conditions.graphicalUser;
    package = pkgs.thunderbird-latest;
  };
}

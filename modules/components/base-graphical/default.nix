{ lib, ... }:
let
  chromiumPasswordStore = "--password-store=kwallet6";
in
{
  flake.modules.nixos.base-graphical = { pkgs, config, ... }: {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          ControllerMode = "dual";
          PairableTimeout = 120;
        };
      };
    };

    services.blueman = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      local.foot
      # neohtop
      xdg-utils
      local.zen-browser
      (brave.override {
        commandLineArgs = [
          chromiumPasswordStore
          "--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoDecodeLinuxGL"
          "--ignore-gpu-blocklist"
          "--enable-zero-copy"
        ];
      })
      pavucontrol
      libnotify
      vulkan-tools
      wev
      flameshot

      obsidian
      logseq

      (local.vscodium.override { commandLineArgs = [ chromiumPasswordStore ]; }).fhs
      geany

      featherpad
      zed-editor

      glib

      papirus-icon-theme
      yaru-theme

      syncthing
      # waybar
      wlsunset

      wl-clipboard

      wlr-randr wlopm shikane
      # nwg-displays
      keepassxc
      seahorse

      nautilus

      cosmic-term
      cosmic-edit
      cosmic-files
      cosmic-reader

      lxqt.pcmanfm-qt
      lxqt.lximage-qt
      lxqt.lxqt-archiver
      lxqt.qps

      qalculate-gtk
      imv
      qview
      # clapper

      # PDF Viewer
      papers
      foliate
      # kdePackages.okular

      libsForQt5.qt5.qtwayland
      # libsForQt5.qt5ct

      kdePackages.qtwayland
      kdePackages.qtsvg
      kdePackages.qt6ct
      kdePackages.qtstyleplugin-kvantum

      # kdePackages.ark
      # kdePackages.kate
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

      xorg.xprop
      libva-utils
      waypaper
      # glxinfo
      pinta

      yubikey-manager

      bustle
    ];

    qt = {
      enable = true;
    };

    services.gvfs = {
      enable = true;
      package = pkgs.gvfs;
    };

    services.fwupd = {
      enable = true;
    };

    # Workaround for Dolphin MIME
    # environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

    xdg.portal = {
      enable = true;
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

    programs.gnome-disks = {
      enable = true;
    };

    programs.dconf = {
      enable = true;
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

    programs.xwayland = {
      enable = true;
    };

    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird-latest;
    };

  };

  flake.modules.homeManager.base-graphical = { pkgs, config, osConfig, configData, ... }: {
    home.pointerCursor = {
      name = "macOS (SVG)";
      package = pkgs.local.macos-hyprcursor;
      size = 24;
      gtk.enable = true;
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
        name = "Yaru-prussiangreen-dark";
        package = pkgs.yaru-theme;
      };
    };

    # xdg.configFile = {
    #   "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=KvArcDark";
    # };

  };
}

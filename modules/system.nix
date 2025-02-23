{ config, inputs, lib, pkgs, configData, conditions , hostName, nix-secrets, betterfox, ... }:
let
  foot-with-patches = import ../packages/foot { inherit pkgs; };
in
{
  imports = [
    ./secrets.nix
    ./network.nix
    ./systemd.nix
    ./fonts.nix
    ./display-manager.nix
  ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${configData.username}" = {
     isNormalUser = true;
     extraGroups = [ "wheel" "network" "networkmanager" "audio" "video" "storage" "input" ];

     shell = pkgs.nushell;

     packages = with pkgs; [];
  };

  boot = {
    initrd.systemd.enable = lib.mkDefault (conditions.isLaptop && !conditions.isServer);
    # initrd.verbose = false;
    kernel.sysctl = {
      "kernel.sysrq" = lib.mkDefault 1;
      "vm.max_map_count" = 1048576;
    };
    kernelPackages = lib.mkDefault pkgs.linuxPackages_cachyos;
    # kernelParams = [ "quiet" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" ] ++ lib.optionals conditions.isServer [ "consoleblank=120" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    tmp = {
      cleanOnBoot = true;
    };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };

    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  time = {
    timeZone = "Asia/Bangkok";
  };

  i18n = {
    defaultLocale = "en_SG.UTF-8";
    extraLocaleSettings = {
      # https://metacpan.org/dist/DateTime-Locale/view/lib/DateTime/Locale/en_IE.pod
      LC_TIME = "en_IE.UTF-8";
    };
  };

  services.pulseaudio.enable = false;

  security.rtkit.enable = conditions.graphicalUser;
  services.pipewire = {
    enable = conditions.graphicalUser;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth = {
    enable = lib.mkDefault conditions.graphicalUser;
    powerOnBoot = false;
  };
  services.blueman.enable = lib.mkDefault conditions.graphicalUser;

  security.polkit.enable = true;

  security.sudo-rs = {
    enable = true;
    wheelNeedsPassword = lib.mkDefault false;
    execWheelOnly = true;
  };

  security.doas = {
    enable = false;
    wheelNeedsPassword = lib.mkDefault false;
  };

  environment.systemPackages = with pkgs; [
    vim helix kakoune
    curl wget
    xdg-user-dirs
    bash zsh
    gnumake git fastfetch gomplate
    bat ripgrep
    doggo
    openssl
    unzip p7zip
    htop bottom procs
    dbus
    age sops
    devenv

    just
    lshw
    starship
    cmatrix
    # yubikey-manager

    gh
    curlie

    psmisc
    pciutils

    ] ++ lib.optionals conditions.graphicalUser [

    foot-with-patches
    xdg-utils
    floorp
    librewolf
    brave
    pavucontrol
    libnotify
    vulkan-tools
    wev
    flameshot

    vscodium-fhs
    geany
    # zed-editor

    glib

    yaru-theme papirus-icon-theme

    syncthing
    waybar
    wlsunset

    grim slurp
    wl-clipboard

    fuzzel
    mako
    wlr-randr wlopm shikane
    # nwg-displays
    nwg-bar
    keepassxc

    lxqt.pcmanfm-qt
    lxqt.lximage-qt
    lxqt.lxqt-archiver
    lxqt.qps

    qalculate-gtk
    imv
    qview
    photoqt
    mpv

    # PDF Viewer
    zathura
    foliate

    libsForQt5.qt5.qtwayland
    # libsForQt5.qt5ct
    # kdePackages.okular

    kdePackages.qtwayland
    kdePackages.qtsvg
    kdePackages.qt6ct
    kdePackages.qtstyleplugin-kvantum

    # kdePackages.kcoreaddons
    # kdePackages.frameworkintegration
    # kdePackages.plasma-workspace
    # kdePackages.kde-cli-tools
    # kdePackages.breeze

    kdePackages.kwalletmanager

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
    glxinfo
    # yubikey-manager-qt
    pinta
  ] ++ lib.optionals conditions.isWork [
    netbird
  ];

  qt = {
    enable = lib.mkDefault conditions.graphicalUser;
  };

  services.dbus = {
    enable = true;
  };

  services.gvfs = {
    enable = lib.mkDefault conditions.graphicalUser;
    package = pkgs.gvfs;
  };

  services.udisks2 = {
    enable = true;
    settings = {
    	"mount_options.conf" = {
		     defaults = {
					   btrfs_defaults = "compress=zstd";
			   };
      };
    };
  };

  services.fwupd.enable = conditions.isLaptop;

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  services.journald.extraConfig = ''
  SystemMaxUse=1G
  MaxRetentionSec=2week
  '';

  services.ananicy = {
    enable = false;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  xdg.portal = {
    enable = lib.mkDefault conditions.graphicalUser;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      sway = {
        default = lib.mkForce [ "gtk" "wlr" ];
      };
      river = {
        default = [ "gtk" "wlr" ];
      };
      Hyprland = {
        default = [ "Hyprland" ];
      };
    };
  };

  programs.gnome-disks = {
    enable = lib.mkDefault conditions.graphicalUser;
  };

  programs.evince = {
    enable = lib.mkDefault conditions.graphicalUser;
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

  programs.sway = {
    enable = lib.mkDefault conditions.graphicalUser;
    package = pkgs.sway;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [ swaylock swayidle swaybg ];
  };

  programs.river = {
    enable = false;
    xwayland.enable = true;
    extraPackages = with pkgs; [];
  };

  programs.hyprland = {
    enable = false;
    xwayland.enable = true;
  };

  programs.xwayland = {
    enable = lib.mkDefault conditions.graphicalUser;
  };

  programs.firefox = {
    enable = lib.mkDefault conditions.graphicalUser;
  };

  programs.thunderbird = {
    enable = lib.mkDefault conditions.graphicalUser;
    package = pkgs.thunderbird-latest;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = conditions.isServer;

    storageDriver = "btrfs";
  };

  virtualisation.containers = {
    enable = true;
    containersConf.settings = {
      engine = {
        compose_providers = [ "${pkgs.podman-compose}/bin/podman-compose" ];
      };
    };
    storage.settings = {};
  };

  virtualisation.podman = {
    enable = true;
  };

  services.zram-generator = {
    enable = true;
    settings = {
      zram0 = {
        zram-size = "ram / 2";
      };
    };
  };

  services.openssh.hostKeys = [
    {
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];

  services.syncthing = {
    enable = conditions.isServer;
    openDefaultPorts = true;
    guiAddress = "127.0.0.1:8384";
    overrideDevices = false;
    overrideFolders = false;
    settings = {};
  };

  services.logind.lidSwitch = if conditions.isServer then "lock" else "suspend";

  environment.sessionVariables = {
    # "ALACRITTY_SOCKET" = "$XDG_RUNTIME_DIR/alacritty-default.sock";
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

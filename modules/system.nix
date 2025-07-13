{ config, inputs, lib, pkgs, configData, hostConfig, conditions , hostName, nix-secrets, betterfox, ... }:
let
  u2fEnabled = hostConfig.u2fConfig != [];
  foot-with-patches = import ../packages/foot { inherit pkgs; };
  vscodium-with-patches = import ../packages/vscodium { inherit pkgs; };
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
    ./secret-providers/gnome-keyring.nix
    ./secret-providers/oo7-daemon.nix
  ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${configData.username}" = {
     isNormalUser = true;
     extraGroups = [ "wheel" "network" "networkmanager" "audio" "video" "storage" "input" ];

     shell = pkgs.nushell;

     packages = with pkgs; [];
  };

  boot = {
    initrd.systemd.enable = lib.mkDefault (conditions.isLaptop);
    # initrd.verbose = false;
    kernel.sysctl = {
      "kernel.sysrq" = lib.mkDefault 1;
      "vm.max_map_count" = 1048576;
    };
    kernelPackages = lib.mkDefault pkgs.linuxPackages_cachyos;
    kernelParams = lib.optionals conditions.isServer [ "consoleblank=120" ];
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

  security.polkit.enable = true;

  security.sudo-rs = {
    enable = true;
    wheelNeedsPassword = true;
    execWheelOnly = true;
  };

  security.doas = {
    enable = false;
    wheelNeedsPassword = true;
  };

  security.pam.services = {
    login.u2fAuth = u2fEnabled;
    sudo.u2fAuth = u2fEnabled;
  };

  security.pam.u2f = {
    enable = u2fEnabled;
    settings = {
      interactive = false;
      cue = true;

      origin = "pam://${hostName}";
      authfile = pkgs.writeText "u2f-mappings" (lib.concatStrings ([ configData.username ] ++ hostConfig.u2fConfig) );
    };
  };

  environment.systemPackages = with pkgs; [
    btop
    vim helix kakoune
    curl wget
    xdg-user-dirs
    bash zsh
    gnumake git git-cliff
    fastfetch gomplate
    duf bat ripgrep fd
    gping doggo
    dive
    openssl
    unzip p7zip
    htop bottom procs
    dbus
    age sops
    # devenv

    yazi

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
    # firefox
    # librewolf
    floorp
    # qutebrowser
    (brave.override {
      commandLineArgs = [
        "--password-store=gnome-libsecret"
      ];
    })
    pavucontrol
    libnotify
    vulkan-tools
    wev
    flameshot

    obsidian
    logseq

    vscodium-with-patches.fhs
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
    nwg-displays
    nwg-bar
    keepassxc
    seahorse

    nautilus

    lxqt.pcmanfm-qt
    lxqt.lximage-qt
    lxqt.lxqt-archiver
    lxqt.qps

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

    # kdePackages.kcoreaddons
    # kdePackages.frameworkintegration
    # kdePackages.plasma-workspace
    # kdePackages.kde-cli-tools
    # kdePackages.breeze

    # kdePackages.kwalletmanager

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
    pinta

    yubikey-manager

    bustle
  ];

  qt = {
    enable = lib.mkDefault conditions.graphicalUser;
  };

  services.pcscd = {
    enable = false;
  };

  services.dbus = {
    enable = true;
  };

  services.scx = {
    enable = false;
    scheduler = "scx_rustland";
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

  services.fwupd = {
    enable = conditions.isLaptop;
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  services.journald.extraConfig = ''
  SystemMaxUse=1G
  MaxRetentionSec=2week
  '';

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

  secret-providers.gnome-keyring.enable = lib.mkDefault conditions.graphicalUser;
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
  # desktop-sessions.hyprland.enable = lib.mkDefault conditions.hyprland;

  # programs.sway = {
  #   enable = lib.mkDefault conditions.graphicalUser;
  #   package = pkgs.sway;
  #   wrapperFeatures.gtk = true;
  #   extraPackages = with pkgs; [ grim slurp swaylock swayidle swaybg ];
  # };

  programs.river = {
    enable = false;
    xwayland.enable = true;
    extraPackages = with pkgs; [];
  };

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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  virtualisation.docker = {
    enable = lib.mkDefault true;
    enableOnBoot = conditions.isServer;

    storageDriver = "btrfs";
  };

  virtualisation.containers = {
    enable = true;
    containersConf.settings = {
      engine = {
        compose_warning_logs = false;
        compose_providers = [ "${pkgs.podman-compose}/bin/podman-compose" ];
      };
    };
    storage.settings = {};
  };

  virtualisation.podman = {
    enable = lib.mkDefault true;
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

  environment.localBinInPath = true;

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
  system.stateVersion = "25.05"; # Did you read the comment?

}

{ config, inputs, lib, pkgs, configData, isPersonal, isDesktop, hostName, nix-secrets, ... }:
let
  fhspkg = import ../packages/fhs.nix { inherit pkgs; inherit config; inherit lib; };
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
    initrd.systemd.enable = true;
    initrd.verbose = false;
    kernel.sysctl = {
      "kernel.sysrq" = lib.mkDefault 1;
      "vm.max_map_count" = 1048576;
    };
    kernelPackages = lib.mkDefault pkgs.linuxPackages_cachyos-lto;
    kernelParams = [ "quiet" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" ];
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

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  security.polkit.enable = true;

  security.sudo-rs = {
    enable = true;
    wheelNeedsPassword = false;
    execWheelOnly = true;
  };

  security.doas = {
    enable = true;
    wheelNeedsPassword = false;
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    helix
    wget
    gnumake
    git
    bat
    doggo

    openssl

    fhspkg

    age
    sops

    zsh
    foot
    gomplate
    fastfetch
    vscodium-fhs
    geany
    brave
    pavucontrol
    libnotify
    vulkan-tools
    dbus   # make dbus-update-activation-environment available in the path

    xdg-utils # for opening default programs when clicking links
    glib # gsettings

    yaru-theme
    # sweet
    papirus-icon-theme

    waybar
    wlsunset

    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    fuzzel
    mako
    htop
    wlr-randr
    wlopm
    kanshi
    nwg-displays
    nwg-bar
    keepassxc
    syncthing
    lxqt.pcmanfm-qt
    lxqt.lximage-qt
    lxqt.lxqt-archiver
    lxqt.qps
    p7zip
    qalculate-gtk
    mpv

    # PDF Viewer
    zathura
    mate.atril

    libsForQt5.qt5.qtwayland
    # libsForQt5.qt5ct
    # libsForQt5.qtstyleplugin-kvantum
    # kdePackages.okular

    kdePackages.qtwayland
    kdePackages.qtsvg
    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum

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

    procs
    xorg.xprop
    xdotool
    xorg.xwininfo
    unzip
    libva-utils
    waypaper
    glxinfo
    ripgrep
    xdg-user-dirs
    busybox
    lshw
    just
    starship
    cmatrix

    yubikey-manager
    yubikey-manager-qt
    cryptsetup
    # opensc

    zed-editor

    pinta

    netbird

    devenv
    mission-center
    bottom
  ];

  qt = {
    enable = true;
  };

  services.emacs = {
    enable = false;
    package = pkgs.emacs29-pgtk;
  };

  services.dbus = {
    enable = true;
  };

  services.gvfs = {
    enable = true;
    package = pkgs.gvfs;
  };

  services.udisks2.enable = true;

  services.fwupd.enable = true;

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
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      sway = {
        default = [ "gtk" "wlr" ];
      };
      river = {
        default = [ "gtk" "wlr" ];
      };
      hyprland = {
        default = [ "hyprland" ];
      };
    };
  };

  chaotic.scx = {
    enable = false;
    scheduler = lib.mkDefault "scx_rustland";
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

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [ swaylock swayidle swaybg ];
  };

  programs.river = {
    enable = true;
    xwayland.enable = true;
    extraPackages = with pkgs; [ kanshi ];
  };

  programs.hyprland = {
    enable = false;
    xwayland.enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.xwayland = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;

    storageDriver = "btrfs";
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
  system.stateVersion = "24.05"; # Did you read the comment?

}

{ config, inputs, lib, pkgs, pkgs-stable, configData, isPersonal, isDesktop, hostName, ... }:

{
  imports = [
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

  # systemd.package = pkgs-stable.systemd;

  boot = {
    kernel.sysctl = {
      "kernel.sysrq" = lib.mkDefault 1;
      "vm.max_map_count" = 1048576;
    };
    kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
    kernelParams = ["quiet"];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
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

  networking = {
    hostName = hostName;
    networkmanager.enable = true;
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  systemd.user.services = {
    polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
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

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  security.polkit.enable = true;

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
    greetd.tuigreet
    zsh
    foot
    gomplate
    neofetch
    geany
    pavucontrol
    libnotify
    vulkan-tools
    dbus   # make dbus-update-activation-environment available in the path
    wayland
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    xdg-utils # for opening default programs when clicking links
    glib # gsettings
    yaru-theme
    papirus-icon-theme
    waybar
    wlsunset
    swaylock
    swayidle
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    fuzzel
    fnott
    (chromium.override {
      commandLineArgs = [
        "--password-store=gnome-libsecret"
        "--gtk-version=4"
      ];
    })
    htop
    wlr-randr
    nwg-displays
    nwg-bar
    keepassxc
    syncthing
    lxqt.pcmanfm-qt
    lxqt.lximage-qt
    lxqt.lxqt-archiver
    p7zip
    qalculate-gtk
    cinnamon.nemo
    mpv
    gnome.gnome-system-monitor
    mate.atril
    xorg.xprop
    xdotool
    xorg.xwininfo
    yad
    unzip
    networkmanagerapplet
    libva-utils
    qbittorrent
    swaybg
    waypaper
    media-downloader
    yt-dlp
    glxinfo
    ripgrep
    xdg-user-dirs
    busybox
    lshw
    just
    starship
    cmatrix
  ];

  services.dbus.enable = true;

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

  services.gnome.gnome-keyring = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
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
          };
        }
      ];
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [ swaylock swayidle ];
  };

  # programs.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  # };

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

  programs.steam = {
    enable = isPersonal;

    # Unsetting TZ env means 2 conflicting things:
    # - Proton and games themselves will use correct timezone, corresponding to Linux System Timezone: https://github.com/NixOS/nixpkgs/issues/279893#issuecomment-1883875778
    # - Steam itself will show incorrect timezone (always defaulted to UTC) in gameoverlay: https://github.com/ValveSoftware/steam-for-linux/issues/10057
    # package = pkgs.steam-small.override {
    #   extraProfile = ''
    #   unset TZ;
    #   '';
    # };
    package = pkgs.steam;
  };

  programs.gamemode = {
    enable = isPersonal;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;

    storageDriver = "btrfs";
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
  system.stateVersion = "23.11"; # Did you read the comment?

}

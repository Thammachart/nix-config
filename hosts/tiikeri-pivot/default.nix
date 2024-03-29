{ config, lib, pkgs, pkgs-unstable, ... }:

let
  launch-sway = import ../../packages/sway-custom.nix { inherit pkgs; };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./custom-hardware-configuration.nix
      ./fonts.nix
      ./login-manager.nix
    ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thammachart = {
     isNormalUser = true;
     extraGroups = [ "wheel" "network" "networkmanager" "audio" "video" "storage" "input" ];

     shell = pkgs-unstable.nushell;

     packages = with pkgs; [];
  };

  # systemd.package = pkgs-unstable.systemd;

  boot = {
    kernel.sysctl = {
      "kernel.sysrq" = 1;
    };
    kernelPackages = pkgs-unstable.linuxPackages_zen;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nix = {
    # Enable Flakes and the new command-line tool
    settings.experimental-features = [ "nix-command" "flakes" ];

    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  networking = {
    hostName = "tiikeri-pivot";
    networkmanager.enable = true;
  };
  systemd.services.NetworkManager-wait-online.enable = false;

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
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
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
    dbus   # make dbus-update-activation-environment available in the path
    wayland
    xwayland
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    xdg-utils # for opening default programs when clicking links
    lsd
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
    mako # notification system developed by swaywm maintainer
    chromium
    htop
    wlr-randr
    nwg-displays
    nwg-bar
    keepassxc
    syncthing
    lxqt.pcmanfm-qt
    lxqt.lximage-qt
    qalculate-gtk
    cinnamon.nemo
    mpv
    gnome.gnome-system-monitor
    mate.atril
    protonup-qt
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
    nvd
    launch-sway
    media-downloader
    yt-dlp
    glxinfo
    ripgrep
  ] ++ [];

  services.dbus.enable = true;

  services.udisks2.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.gnome.gnome-keyring = {
    enable = true;
  };

  programs.gnome-disks = {
    enable = true;
  };

  programs.dconf.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
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

  programs.steam = {
    enable = true;

    # unset TZ env var to force Proton to correctly set timezone according to Linux System Timezone: https://github.com/NixOS/nixpkgs/issues/279893#issuecomment-1883875778
    package = pkgs.steam-small.override {
      extraProfile = ''
      unset TZ;
      '';
    };
  };

  programs.gamemode = {
    enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;

    package = pkgs-unstable.docker;
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

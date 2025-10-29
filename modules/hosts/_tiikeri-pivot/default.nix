{config, lib, pkgs, conditions, configData, ...}:
let
  shouldEnable = conditions.isPersonal;
in
{
  flake.modules.nixos.hosts."hosts/tiikeri-pivot".imports =
      with (config.flake.modules.nixos);
      [
        ai
        base
        bluetooth
        desktop
        dev
        #       email
        facter
        fwupd
        # games
        #       guacamole
        # messaging # only home modules exist for messaging, currently
        mimi
        openssh
        root
        shell
        sound
        virtualisation
        vpn
        #       work
      ]
      ++ [
        {
          home-manager.users.mimi.imports = with config.flake.modules.homeManager; [
            # ai # already defined in nixos base
            base # already defined in nixos base
            # "bluetooth"
            desktop
            dev
            email
            facter # already defined in nixos base
            # fwupd
            games
            #       "guacamole"
            messaging
            # "openssh" # only system/nixos module exists???
            shell # already defined in nixos base
            # sound
            # virtualisation
            vpn # already defined in nixos base
            #       "work"
            # laptop
          ];
        }
      ];
  imports =
    [
      ./disko-fs.nix
      ./secrets.nix
      ./hardware-configuration.nix
      ./custom-hardware-configuration.nix
      ../../modules/system.nix
    ];

  # boot.kernelPackages = pkgs.linuxPackages_zen;

  users.users."${configData.username}".extraGroups = [ "docker" "kvm" ];

  environment.systemPackages = with pkgs; [
    nvtopPackages.intel

    protonup-qt

    media-downloader
    yt-dlp
    gallery-dl

    # xivlauncher

    qbittorrent-enhanced

    aria2

    gamescope
    mangohud

    protonmail-desktop

    # rpcs3
    # heroic
    # cryptomator
  ];

}

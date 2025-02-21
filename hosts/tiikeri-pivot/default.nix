{config, lib, pkgs, conditions, configData, ...}:
let
  shouldEnable = conditions.isPersonal;
in
{
  imports =
    [
      ./disko-fs.nix
      ./secrets.nix
      ./hardware-configuration.nix
      ./custom-hardware-configuration.nix
      ../../modules/system.nix
    ];

  users.users."${configData.username}".extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    btop
    intel-gpu-tools

    signal-desktop
    protonup-qt

    media-downloader
    curl-impersonate
    yt-dlp

    # pkgs.xivlauncher

    qbittorrent

    aria2

    gamescope
    mangohud

    # pkgs.heroic
    # pkgs.cryptomator
  ];

  programs.steam = {
    enable = shouldEnable;

    # Unsetting TZ env means 2 conflicting things:
    # - Proton and games themselves will use correct timezone, corresponding to Linux System Timezone: https://github.com/NixOS/nixpkgs/issues/279893#issuecomment-1883875778
    # - Steam itself will show incorrect timezone (always defaulted to UTC) in gameoverlay: https://github.com/ValveSoftware/steam-for-linux/issues/10057
    # package = pkgs.steam-small.override {
    #   extraProfile = ''
    #   unset TZ;
    #   '';
    # };
    package = pkgs.steam;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamemode = {
    enable = shouldEnable;
  };
}

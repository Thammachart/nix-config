{config, pkgs, isPersonal, ...}:
{
  imports =
    [
      ./secrets.nix
      ./hardware-configuration.nix
      ./custom-hardware-configuration.nix
      ../../modules/system.nix
    ];

  environment.systemPackages = [
    pkgs.signal-desktop
    pkgs.protonup-qt

    pkgs.media-downloader
    pkgs.yt-dlp

    pkgs.xivlauncher

    pkgs.qbittorrent
    # pkgs.cryptomator
  ];

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

}

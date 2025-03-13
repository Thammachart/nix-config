{config, configData, pkgs, ...}:
{
  imports =
    [
      ./disko-fs.nix
      ./secrets.nix
      ./hardware-configuration.nix
      ./custom-hardware-configuration.nix
      ../../modules/system.nix
    ];
  environment.systemPackages = with pkgs; [
    qbittorrent-enhanced
    media-downloader
  ];
}

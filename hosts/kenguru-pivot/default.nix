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

    boot.kernelPackages = pkgs.linuxPackages_latest;

    users.users."${configData.username}".extraGroups = ["docker"];
}

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

    users.users."${configData.username}".extraGroups = [ "docker" ];
}

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

    virtualisation.incus = {
      enable = true;
      ui.enable = true;
    };

    networking.nftables.enable = true;

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 8443 ];
    };
}

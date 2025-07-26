{ lib, config, configData, hostConfig, pkgs, ... }:
{
  imports =
    [
      ./network.nix
      ./incus.nix
      ./disko-fs.nix
      ./secrets.nix
      ./hardware-configuration.nix
      ./custom-hardware-configuration.nix
      ../../modules/system.nix
    ];

  users.users."${configData.username}".extraGroups = [ "incus-admin" ];

  boot.kernelPackages = pkgs.linuxPackages;

  virtualisation.docker = {
    enable = false;
  };

  virtualisation.podman = {
    enable = false;
  };
}

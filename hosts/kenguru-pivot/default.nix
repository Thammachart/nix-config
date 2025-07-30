{ lib, config, configData, hostConfig, pkgs, ... }:
{
  imports =
    [
      ./network.nix
      ./incus.nix
      ./k3s.nix
      ./disko-fs.nix
      ./secrets.nix
      ./hardware-configuration.nix
      ./custom-hardware-configuration.nix
      ../../modules/system.nix
    ];

  users.users."${configData.username}".extraGroups = [ "incus-admin" ];

  boot.kernelPackages = pkgs.linuxPackages;

  environment.systemPackages = (with pkgs; [
    caddy
    kubernetes-helm
    k9s
    kdash
  ]);

  virtualisation.docker = {
    enable = false;
  };

  virtualisation.podman = {
    enable = false;
  };
}

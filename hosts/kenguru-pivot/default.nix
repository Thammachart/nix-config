{config, configData, pkgs, ...}:
let
  defaultInterface = "enp5s0";
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

  users.users."${configData.username}".extraGroups = [ "incus-admin" ];

  boot.kernelPackages = pkgs.linuxPackages;

  virtualisation.docker = {
    enable = false;
  };

  virtualisation.podman = {
    enable = false;
  };

  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };

  networking = {
    networkmanager.enable = false;

    nftables.enable = true;

    interfaces."${defaultInterface}" = {
      ipv4.addresses = [{
        address = "192.168.0.5";
        prefixLength = 16;
      }];
      ipv6.addresses = [{
        address = "fd00::5";
        prefixLength = 96;
      }];
    };

    defaultGateway = {
      address = "192.168.0.1";
      interface = "${defaultInterface}";
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 8443 ];
    };

    bridges = {};
  };




}

{ lib, config, configData, hostConfig, pkgs, ... }:
let
  defaultInterface = hostConfig.networking.ifname;
  defaultBridge = "br0";
  ipv4 = lib.splitString "/" hostConfig.networking.v4.ipaddr;
  ipv6 = lib.splitString "/" hostConfig.networking.v6.ipaddr;
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
    useDHCP = false;
    dhcpcd.enable = false;

    networkmanager.enable = false;

    nftables.enable = true;

    nameservers = (configData.networking.default.DNS4 ++ configData.networking.default.DNS6);

    interfaces."${defaultInterface}" = {};

    interfaces."${defaultBridge}" = {
      ipv4.addresses = [{
        address = lib.head ipv4;
        prefixLength = lib.toInt (lib.last ipv4);
      }];
      ipv6.addresses = [{
        address = lib.head ipv6;
        prefixLength = lib.toInt (lib.last ipv6);
      }];
    };

    defaultGateway = {
      address = configData.networking.default.Gateway4;
      interface = "${defaultBridge}";
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 8443 ];
    };

    bridges = {
      "${defaultBridge}" = {
        interfaces = [ defaultInterface ];
      };
    };
  };
}

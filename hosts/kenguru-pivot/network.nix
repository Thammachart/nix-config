{ lib, config, configData, hostConfig, pkgs, ... }:
let
  defaultInterface = hostConfig.networking.ifname;
  defaultIncusBridge = hostConfig.networking.incusBridgeIfname;
  ipv4 = lib.splitString "/" hostConfig.networking.v4.ipaddr;
  ipv6 = lib.splitString "/" hostConfig.networking.v6.ipaddr;
in
{
  networking = {
    useDHCP = false;
    dhcpcd.enable = false;

    networkmanager.enable = false;

    nameservers = (configData.networking.default.DNS4 ++ configData.networking.default.DNS6);

    interfaces."${defaultInterface}" = {
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
      interface = "${defaultInterface}";
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 8443 ];

      interfaces."${defaultIncusBridge}" = {
        allowedTCPPorts = [ 53 67 ];
        allowedUDPPorts = [ 53 67 ];
      };
    };
  };
}

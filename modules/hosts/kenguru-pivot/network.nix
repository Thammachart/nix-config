{ lib, ... }:
{
  flake.modules.nixos.hosts_kenguru-pivot = { pkgs, config, hostConfig, ... }:
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

      nameservers = (config.configData.networking.default.DNS4 ++ config.configData.networking.default.DNS6);

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
        address = config.configData.networking.default.Gateway4;
        interface = "${defaultInterface}";
      };
    };
  };
}

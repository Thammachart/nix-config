{ lib, config, configData, hostConfig, pkgs, conditions, ... }:
let
  defaultIncusBridge = hostConfig.networking.incusBridgeIfname;
in
{
  virtualisation.incus = {
    enable = lib.mkDefault conditions.incus;
    ui.enable = true;
    preseed = {
      networks = [
        {
          config = {
            "ipv4.address" = "10.100.100.1/24";
            "ipv4.nat" = "true";
          };
          name = defaultIncusBridge;
          type = "bridge";
        }
      ];
      projects = [
        { name = "default"; } { name = "local-k8s"; }
      ];
      profiles = [
        {
          devices = {
            eth0 = {
              name = "eth0";
              network = defaultIncusBridge;
              type = "nic";
            };
            root = {
              path = "/";
              pool = "local";
              size = "60GiB";
              type = "disk";
            };
          };
          name = "default";
        }
        {
          devices = {
            eth0 = {
              name = "eth0";
              network = defaultIncusBridge;
              type = "nic";
            };
            root = {
              path = "/";
              pool = "local";
              size = "60GiB";
              type = "disk";
            };
          };
          project = "local-k8s";
          name = "default";
        }
      ];
      storage_pools = [
        {
          driver = "btrfs";
          name = "local";
        }
      ];
    };
  };
}

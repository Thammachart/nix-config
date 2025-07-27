{ lib, config, configData, hostConfig, pkgs, conditions, ... }:
let
  defaultIncusBridge = hostConfig.networking.incusBridgeIfname;
  defaultProfileSetting = {
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
  };
in
{
  virtualisation.incus = {
    enable = lib.mkDefault conditions.incus;
    ui.enable = true;
    preseed = {
      networks = [
        {
          config = {
            "ipv4.address" = "192.168.100.1/24";
            "ipv4.nat" = "true";
            "ipv6.address" = "fd00::100:1/96";
            "ipv6.nat" = "true";
            "ipv6.dhcp.ranges" = "fd00::100:50-fd00::100:70";
            "ipv6.dhcp.stateful" = "true";
          };
          name = defaultIncusBridge;
          type = "bridge";
        }
      ];
      projects = [
        { name = "default"; } { name = "local-k8s"; description = "K8s"; } { name = "local-k3s"; description = "K3s"; }
      ];
      profiles = [
        (defaultProfileSetting // { project = "default"; name = "default"; })
        (defaultProfileSetting // { project = "local-k8s"; name = "k8s"; })
        (defaultProfileSetting // { project = "local-k3s"; name = "k3s"; })
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

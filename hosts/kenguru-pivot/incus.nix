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
            "ipv4.address" = "10.100.0.1/16";
            "ipv4.nat" = "true";
            "ipv6.address" = "fda0::1/96";
            "ipv6.nat" = "true";
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

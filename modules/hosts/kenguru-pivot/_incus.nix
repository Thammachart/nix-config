{ lib, config, configData, hostConfig, pkgs, conditions, ... }:
let
  defaultIncusBridge = hostConfig.networking.incusBridgeIfname;
  defaultProfileSetting = {
    config = {
      "limits.cpu" = "2";
      "limits.memory" = "4GiB";
      "limits.memory.swap" = "false";
    };

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
lib.mkIf conditions.incus {

  networking.firewall = {
    allowedTCPPorts = [ 8443 ];
    trustedInterfaces = [ defaultIncusBridge ];
  };

  virtualisation.incus = {
    enable = true;
    ui.enable = true;
    preseed = {
      config = {
        "core.https_address" = "0.0.0.0:8443";
      };
      networks = [
        {
          config = {
            "ipv4.address" = "10.0.0.1/8";
            "ipv4.nat" = "true";
            "ipv4.dhcp.ranges" = "10.1.0.1-10.1.15.254";
            "ipv6.address" = "fda0::1/96";
            "ipv6.nat" = "true";
            "ipv6.dhcp.ranges" = "fda0::1:1-fda0::2:1";
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
          name = "local";
          driver = "btrfs";
        }
      ];
    };
  };
}

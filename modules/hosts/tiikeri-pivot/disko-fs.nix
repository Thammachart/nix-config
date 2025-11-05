{ config, ... }:
let
  hostname = "tiikeri-pivot";
  diskoCfg = config.flake.diskoConfigurations."${hostname}";
in
{
  flake.diskoConfigurations."${hostname}" = {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/nvme0n1";

          content = {
            type = "gpt";
            partitions = {
              ESP = {
                type = "EF00";
                size = "1G";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  extraArgs = [ "-F32" ];
                  mountpoint = "/boot";
                  mountOptions = [ "defaults" "noatime" ];
                };
              };
              root-system = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];

                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [ "noatime" "commit=120" "compress=zstd" ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [ "noatime" "commit=120" "compress=zstd" ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "noatime" "commit=120" "compress=zstd" ];
                    };
                  };
                };
              };
            };
          };
        };

        secondary-nvme = {
          type = "disk";
          device = "/dev/nvme1n1";

          content = {
            type = "gpt";
            partitions = {
              nvme1 = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "btrfs";
                  mountpoint = "/data/nvme1";
                  mountOptions = [ "nofail" "noatime" "commit=120" "compress=zstd" ];
                };
              };
            };
          };
        };
      };
    };
  };

  flake.modules.nixos."hosts_${hostname}" = {
    imports = [ diskoCfg ];
  };
}

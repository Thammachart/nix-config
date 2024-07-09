{
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
                extraArgs = [ "-F 32" ];
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
                mountOptions = [ "noatime" "commit=120" "compress=zstd" ];
              };
            };
          };
        };
      };

      secondary-sda = {
        type = "disk";
        device = "/dev/sda";
        
        content = {
          type = "gpt";
          partitions = {
            sda1 = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/data/sda1";
                mountOptions = [ "noatime" "commit=120" "compress=zstd" "autodefrag" ];
              };
            };
          };
        };
      };
    };
  };
}
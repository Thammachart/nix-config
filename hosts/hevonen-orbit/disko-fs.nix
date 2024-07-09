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
              size = "1GiB";
              content = {
                type = "filesystem";
                format = "vfat";
                extraArgs = [ "-F 32" ];
                mountpoint = "/boot";
                mountOptions = [ "defaults" "noatime" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted-nixos";

                # disable settings.keyFile if you want to use interactive password entry
                settings = {
                  # keyFile = "/tmp/secret.key";
                  allowDiscards = true;
                  fallbackToPassword = true;
                  bypassWorkqueues = true;
                };
                # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                
                extraFormatArgs = [
                  "--type luks2"
                  "--use-random"
                  "--hash sha512"
                  "--iter-time 3000"
                ];
                extraOpenArgs = [ "--timeout 10" ];

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
      };
    };
  };
}
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
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                extraArgs = [ "-F32" ];
                mountpoint = "/boot";
                mountOptions = [ "defaults" "noatime" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted-nixos";

                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                  crypttabExtraOpts = ["tpm2-device=auto" "token-timeout=10"];
                };

                extraFormatArgs = [
                  "--type luks2"
                  "--use-random"
                  "--hash blake2b-512"
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

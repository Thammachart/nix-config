{ config, lib, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];

  fileSystems."/".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@" ];

  fileSystems."/home".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@home" ];

  fileSystems."/nix".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@nix" ];

  fileSystems."/boot".options = [ "noatime" ];

  fileSystems."/data/nvme1" = 
    { device = "/dev/disk/by-uuid/72e9114f-495e-4e5a-9aba-a8527bd14542";
      fsType = "btrfs";
      options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" ];
    };

  fileSystems."/data/sda1" = 
    { device = "/dev/disk/by-uuid/c426199f-8cf4-49cf-a982-a1cc87bd774c";
      fsType = "btrfs";
      options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "autodefrag" ];
    };

  hardware.opengl = {
    enable = true;

    driSupport = true;
    driSupport32Bit = true;

    extraPackages = with pkgs; [
      amdvlk
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      amdvlk
    ];
  };

  # Force radv
  environment.variables.AMD_VULKAN_ICD = "RADV";
}

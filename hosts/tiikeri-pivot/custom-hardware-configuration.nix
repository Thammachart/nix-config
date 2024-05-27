{ config, lib, pkgs, pkgs-stable, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];

  fileSystems."/".options = [ "noatime" "commit=120" "compress=zstd" "space_cache=v2" "subvol=@" ];

  fileSystems."/home".options = [ "noatime" "commit=120" "compress=zstd" "space_cache=v2" "subvol=@home" ];

  fileSystems."/nix".options = [ "noatime" "commit=120" "compress=zstd" "space_cache=v2" "subvol=@nix" ];

  fileSystems."/boot".options = [ "noatime" ];

  fileSystems."/data/nvme1" = 
    { device = "/dev/disk/by-uuid/63755e6f-d418-412d-b6a7-af4f403e8d65";
      fsType = "btrfs";
      options = [ "noatime" "commit=120" "compress=zstd" "space_cache=v2" ];
    };

  fileSystems."/data/sda1" = 
    { device = "/dev/disk/by-uuid/58ebec05-bf11-4cea-98df-77dc44558d1f";
      fsType = "btrfs";
      options = [ "noatime" "commit=120" "compress=zstd" "space_cache=v2" "autodefrag" ];
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
  # environment.variables.AMD_VULKAN_ICD = "RADV";
  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
}

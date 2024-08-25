{ config, lib, pkgs, pkgs-stable, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];

  boot.plymouth = {
    enable = false;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

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

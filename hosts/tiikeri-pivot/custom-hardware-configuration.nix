{ config, lib, pkgs, ... }:

{
  boot.initrd.kernelModules = [];

  boot.plymouth = {
    enable = false;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
    ];
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
}

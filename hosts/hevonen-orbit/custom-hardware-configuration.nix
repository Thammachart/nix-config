{ config, lib, pkgs, pkgs-stable, nixos-hardware, modulesPath, ... }:

{
  # imports = [
  #   nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
  # ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
  };
}

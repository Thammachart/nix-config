{config, pkgs, ...}:
{
  imports =
    [
      ./hardware-configuration.nix
      ./custom-hardware-configuration.nix
      ../../modules/system.nix
    ];

  environment.systemPackages = [
    pkgs.signal-desktop
    pkgs.protonup-qt
  ];
}

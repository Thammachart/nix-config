
{
  flake.modules.nixos.hosts_asiantuntija-orbit = { pkgs, config, ... }: {
    conditions.isLaptop = true;

    boot.initrd.systemd.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_zen;

  };
}

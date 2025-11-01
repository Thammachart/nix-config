{
  flake.modules.nixos.ssh = { pkgs, config, hostname, ... }: {
    services.openssh = {
      enable = true;
      banner = "${hostname} via ssh!\n";
    };
  };
}

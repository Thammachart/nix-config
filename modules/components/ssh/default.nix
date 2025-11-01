{
  flake.modules.nixos.ssh = { pkgs, config, hostname, ... }: {
    services.openssh = {
      enable = true;
      banner = "${hostName} via ssh!\n";
    };
  };
}

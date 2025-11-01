{

  flake.modules.nixos.tailscale = { pkgs, config, hostname, ... }: {
    services.tailscale = {
      enable = true;
    };
    systemd.services.tailscaled.wantedBy = if (isClient && config.systemd.services.tailscaled != {}) then (lib.mkForce []) else [];
  };
}

{ ... }:
{
  flake.modules.nixos.messaging = { pkgs,... }: {
    environment.systemPackages = [ pkgs.signal-desktop-bin ];
  };
}

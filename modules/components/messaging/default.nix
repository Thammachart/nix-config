{ ... }:
{
  flake.modules.nixos.messaging = { pkgs,... }: {
    environment.systemPackages = with pkgs; [ signal-desktop telegram-desktop ];
  };
}

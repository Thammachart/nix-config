{ lib, ... }:
{
  flake.modules.nixos.messaging = { pkgs,... }: {
    kernelParams = lib.optionals conditions.isServer [ "consoleblank=120" ];
  };
}

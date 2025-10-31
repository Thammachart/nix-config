{ lib, ... }:
{
  flake.modules.nixos.server = { pkgs,... }: {
    boot.kernelParams = [ "consoleblank=120" ];

    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      guiAddress = "127.0.0.1:8384";
      overrideDevices = false;
      overrideFolders = false;
      settings = {};
    };

    services.logind.settings.Login.HandleLidSwitch = "lock";
  };
}

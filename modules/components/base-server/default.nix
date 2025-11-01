{ lib, ... }:
{
  flake.modules.nixos.base-server = { pkgs,... }: {
    boot = {
      initrd.systemd.enable = true;
      kernelParams = [ "consoleblank=120" ];
    };

    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      guiAddress = "127.0.0.1:8384";
      overrideDevices = false;
      overrideFolders = false;
      settings = {};
    };

    services.logind.settings.Login.HandleLidSwitch = "lock";

    services.resolved.enable = false;

    tailscale.autostart = true;
  };
}

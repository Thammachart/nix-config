{
  flake.modules.nixos.tuta = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ tutanota-desktop ];
  };

  flake.modules.homeManager.tuta = { pkgs, config, ... }: {
    xdg.desktopEntries.tuta = {
      name = "Tuta Mail (Wayland)";
      exec = "tutanota-desktop --ozone-platform=wayland";
      terminal = false;
      categories = [ "Email" ];
      mimeType = [];
    };
  };
}

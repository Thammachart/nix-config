{ pkgs, ... }:


let
  wl-enable = import ./wl-enable.nix { pkgs = pkgs; };

  launch-sway = pkgs.writeScriptBin "launch-sway" ''
    source ${wl-enable}

    export XDG_SESSION_DESKTOP=sway
    export XDG_CURRENT_DESKTOP=sway
    export QT_QPA_PLATFORMTHEME=qt5ct

    exec systemd-cat --identifier=sway sway $@
  '';

  sway-custom = pkgs.writeTextFile {
    name = "sway-custom.desktop";
    destination = "/share/wayland-sessions/sway-custom.desktop";
    text = ''
    [Desktop Entry]
    Name=Sway (Custom)
    Comment=An i2-compatible Wayland compositor with env vars
    Exec=${launch-sway}/bin/launch-sway
    Type=Application
    '';
  };
in {
  environment.systemPackages = [ launch-sway ];
}

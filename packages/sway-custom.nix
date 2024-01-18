{ pkgs, ... }:


let
  launch-sway = pkgs.writeScriptBin "launch-sway" ''
    #! ${pkgs.bash}/bin/sh

    source ${pkgs.wl-envs}

    export XDG_SESSION_DESKTOP=sway
    export XDG_CURRENT_DESKTOP=sway
    export QT_QPA_PLATFORMTHEME=qt4ct

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
  imports = [ ./wl-enable.nix ];

  environment.systemPackages = [ launch-sway ];
}

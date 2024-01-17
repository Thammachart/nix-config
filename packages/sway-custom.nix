{ pkgs, ... }:

let
  wl-envs = pkgs.writeText "wayland-enablement" ''
    export XDG_SESSION_TYPE=wayland
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
    export CLUTTER_BACKEND=wayland
    export ECORE_EVAS_ENGINE=wayland-egl
    export ELM_ENGINE=wayland_egl
    export SDL_VIDEODRIVER=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
    export NO_AT_BRIDGE=1
  '';

  launch-sway = pkgs.writeScriptBin "launch-sway" ''
    #! ${pkgs.bash}/bin/sh

    source ${wl-envs}

    export XDG_SESSION_DESKTOP=sway
    export XDG_CURRENT_DESKTOP=sway
    export QT_QPA_PLATFORMTHEME=qt5ct

    exec systemd-cat --identifier=sway sway $@
  ''

  sway-custom = pkgs.writeTextFile {
    name = "sway-custom.desktop";
    destination = "/share/wayland-sessions/sway-custom.desktop";
    text = ''
    [Desktop Entry]
    Name=Sway (Custom)
    Comment=An i3-compatible Wayland compositor with env vars
    Exec=${launch-sway}/bin/launch-sway
    Type=Application
    '';
  };
in {
  environment.systemPackages = [ launch-sway sway-custom ];
}

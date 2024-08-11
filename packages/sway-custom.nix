{ pkgs, ... }:

let
  wl-enable = import ./wl-enable.nix { inherit pkgs; };

  launch = pkgs.writeScriptBin "launch-sway" ''
    source ${wl-enable}

    export XDG_SESSION_DESKTOP=sway
    export XDG_CURRENT_DESKTOP=sway

    exec systemd-cat --identifier=sway sway $@
  '';

  custom-raw = pkgs.writeTextFile {
    name = "sway-custom-desktop-entries";
    destination = "/share/wayland-sessions/sway-custom.desktop";
    text = ''
    [Desktop Entry]
    Name=Sway (Custom)
    Comment=An i3-compatible Wayland compositor with env vars
    Exec=${launch}/bin/launch-sway
    Type=Application
    '';
  };

  custom-desktop-entry = custom-raw.overrideAttrs {
    passthru.providedSessions = ["sway-custom"];
  };
in
  {
    inherit launch;
    inherit custom-desktop-entry;
  }

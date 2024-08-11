{ pkgs, ... }:

let
  wl-enable = import ./wl-enable.nix { inherit pkgs; };

  launch = pkgs.writeScriptBin "launch-river" ''
    source ${wl-enable}

    export XDG_SESSION_DESKTOP=river
    export XDG_CURRENT_DESKTOP=river

    exec systemd-cat --identifier=river river $@
  '';

  custom-raw = pkgs.writeTextFile {
    name = "river-custom-desktop-entries";
    destination = "/share/wayland-sessions/river-custom.desktop";
    text = ''
    [Desktop Entry]
    Name=river (Custom)
    Comment=A dynamic tiling Wayland compositor
    Exec=${launch}/bin/launch-river
    Type=Application
    '';
  };

  custom-desktop-entry = custom-raw.overrideAttrs {
    passthru.providedSessions = ["river-custom"];
  };
in
  {
    inherit launch;
    inherit custom-desktop-entry;
  }

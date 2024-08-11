{ pkgs, ... }:

let
  wl-enable = import ./wl-enable.nix { inherit pkgs; };

  launch = pkgs.writeScriptBin "launch-hyprland" ''
    source ${wl-enable}

    export XDG_SESSION_DESKTOP=hyprland
    export XDG_CURRENT_DESKTOP=hyprland

    exec systemd-cat --identifier=hyprland Hyprland $@
  '';

  custom-raw = pkgs.writeTextFile {
    name = "hyprland-custom-desktop-entries";
    destination = "/share/wayland-sessions/hyprland-custom.desktop";
    text = ''
    [Desktop Entry]
    Name=Hyprland (Custom)
    Comment=An intelligent dynamic tiling Wayland compositor
    Exec=${launch}/bin/launch-hyprland
    Type=Application
    '';
  };

  custom-desktop-entry = custom-raw.overrideAttrs {
    passthru.providedSessions = ["hyprland-custom"];
  };
in
  {
    inherit launch;
    inherit custom-desktop-entry;
  }

{ pkgs, ... }:


let
  wl-enable = import ./wl-enable.nix { inherit pkgs; };

  launch-hyprland = pkgs.writeScriptBin "launch-hyprland" ''
    source ${wl-enable}

    export XDG_SESSION_DESKTOP=hyprland
    export XDG_CURRENT_DESKTOP=hyprland

    exec systemd-cat --identifier=hyprland Hyprland $@
  '';

  hyprland-custom-raw = pkgs.writeTextFile {
    name = "hyprland-custom-desktop-entries";
    destination = "/share/wayland-sessions/hyprland-custom.desktop";
    text = ''
    [Desktop Entry]
    Name=Hyprland (Custom)
    Comment=An intelligent dynamic tiling Wayland compositor
    Exec=${launch-hyprland}/bin/launch-hyprland
    Type=Application
    '';
  };

  hyprland-custom-desktop-entry = hyprland-custom-raw.overrideAttrs {
    passthru.providedSessions = ["hyprland-custom"];
  };
in 
  { 
    inherit launch-hyprland;
    inherit hyprland-custom-desktop-entry;
  }

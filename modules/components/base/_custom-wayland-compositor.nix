{ pkgs, config }:
{ cmp, exec ? null }:

let
  # wl-enable = import ./wl-enable.nix { inherit pkgs; };

  cmp-exec = if exec != null then exec else cmp;

  launch = pkgs.writeScriptBin "launch" ''
    source ${pkgs.local.wl-enable}

    export XDG_SESSION_DESKTOP=${cmp}
    export XDG_CURRENT_DESKTOP=${cmp}

    set -o allexport
    source <(${config.systemd.package}/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
    set +o allexport

    exec systemd-cat --identifier=${cmp} ${cmp-exec} $@
  '';

  custom-raw = pkgs.writeTextFile {
    name = "${cmp}-custom-desktop-entries";
    destination = "/share/wayland-sessions/${cmp}-custom.desktop";
    text = ''
    [Desktop Entry]
    Name=${cmp} (Custom)
    Comment=${cmp} (Wayland-Enabled)
    Exec=${launch}/bin/launch
    Type=Application
    '';
  };

  custom-desktop-entry = custom-raw.overrideAttrs {
    passthru.providedSessions = ["${cmp}-custom"];
  };
in
  {
    inherit launch;
    inherit custom-desktop-entry;
  }

{ pkgs }:
  name: template: data:
    pkgs.stdenv.mkDerivation {
      name = "${name}";

      nativeBuildInputs = [ pkgs.gomplate ];

      # Pass Json as file to avoid escaping
      passAsFile = [ "jsonData" ];
      jsonData = builtins.toJSON data;

      # Disable phases which are not needed. In particular the unpackPhase will
      # fail, if no src attribute is set
      phases = [ "buildPhase" "installPhase" ];

      buildPhase = ''
        ${pkgs.gomplate}/bin/gomplate -c .="file://''${jsonDataPath}?type=application/json" -f ${template} -o rendered_file
      '';

      installPhase = ''
        cp rendered_file $out
      '';
    }

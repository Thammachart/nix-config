{ pkgs, lib, config, configData, ... }:
{
  options = {
    templateFile = lib.mkOption {
      type = lib.types.anything;
      readOnly = true;
      description = "Template Renderer (Gomplate)";
    };

    wl-cmp = lib.mkOption {
      type = lib.types.anything;
      readOnly = true;
    };

    configData = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
    };
  };

  config.configData = configData;

  config.wl-cmp = import ./_custom-wayland-compositor.nix { inherit pkgs; inherit config; };

  config.templateFile = name: template: data:
    # Run gomplate, using the JSON file as context (from stdin) and the template file as input.
    # The templateFile path is directly interpolated here. Nix handles copying it
    # into the build sandbox.
    pkgs.runCommand "rendered-${name}" {
          nativeBuildInputs = [ pkgs.gomplate ];
        } ''
          echo '${builtins.toJSON data}' | ${pkgs.gomplate}/bin/gomplate \
            --context .=stdin:///in.json \
            --file ${template} \
            --out $out
        '';
}

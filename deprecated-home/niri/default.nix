{ pkgs, config, osConfig, lib, conditions, templateFile, configData, ...  }:

let
in
lib.mkIf osConfig.desktop-sessions.niri.enable {
  # home.file.".config/hypr/variables.conf".source = templateFile "hyprland-vars-${configData.username}" ./variables.conf.tmpl configData.homeSettings;
  home.file.".config/niri/autostart.kdl".source = templateFile "niri-autostart-${configData.username}" ./autostart.kdl.tmpl configData.homeSettings;
  home.file.".config/niri/inputs.kdl".source = templateFile "niri-inputs-${configData.username}" ./inputs.kdl.tmpl { inherit conditions; };
  home.file.".config/niri/binds.kdl".source = templateFile "niri-binds-${configData.username}" ./binds.kdl.tmpl configData.homeSettings;
  home.file.".config/niri/config.kdl".source = templateFile "niri-config-${configData.username}" ./config.kdl.tmpl configData.homeSettings;
}

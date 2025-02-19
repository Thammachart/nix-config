{ pkgs, lib, conditions, templateFile, configData, ...  }:

lib.mkIf conditions.graphicalUser {
  home.file.".config/ghostty/config".source = templateFile "ghostty-config-${configData.username}" ./config.tmpl configData.homeSettings
}

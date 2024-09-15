{ lib, conditions, templateFile, configData, ... }:
lib.mkIf conditions.graphicalUser {
  home.file.".config/fuzzel/fuzzel.ini".source = templateFile "fuzzel-config-${configData.username}" ./fuzzel.ini.tmpl configData.homeSettings;
}

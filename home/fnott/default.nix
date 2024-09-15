{pkgs, lib, conditions, templateFile, configData, ...}:
lib.mkIf conditions.graphicalUser {
  home.file.".config/fnott/fnott.ini".source = templateFile "fnott-config-${configData.username}" ./fnott.ini.tmpl configData.homeSettings;
}

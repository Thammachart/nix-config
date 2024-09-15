{ pkgs, lib, conditions, templateFile, configData, ...  }:

lib.mkIf conditions.graphicalUser {
  home.file.".config/foot/foot.ini".source = templateFile "foot-ini-${configData.username}" ./foot.ini.tmpl configData.homeSettings;
}

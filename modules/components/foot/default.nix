{
  flake.modules.homeManager.foot = { inputs, pkgs, config, configData, ... }:
  let
    cattpuccin = (builtins.readFile "${inputs.catppuccin-foot}/themes/catppuccin-frappe.ini");
    footconfig = (builtins.readFile (config.templateFile "foot-ini" ./foot.ini.tmpl configData.homeSettings));
  in
  {
    home.file.".config/foot/foot.ini".text = ''
    ## Custom Config
    ${footconfig}

    ## Themes
    ${cattpuccin}
    '';
  };
}

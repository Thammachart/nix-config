{
  flake.modules.nixos.nwg-bar = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ nwg-bar ];
  };

  flake.modules.homeManager.nwg-bar = { pkgs, config, ... }:
  let
    settings = { nwgbarPath = pkgs.nwg-bar.outPath; };
  in
  {
    home.file.".config/nwg-bar/exit-bar/bar.json".source = config.templateFile "nwg-bar-json" ./exit-bar/bar.json.tmpl settings;
    home.file.".config/nwg-bar/exit-bar/style.css".source = ./exit-bar/style.css;
  };
}

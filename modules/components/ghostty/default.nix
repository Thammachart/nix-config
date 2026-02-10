{
  flake.modules.nixos.ghostty = { pkgs, ... }: {
    # environment.systemPackages = with pkgs; [ ghostty ];
  };

  flake.modules.homeManager.ghostty = { inputs, pkgs, config, configData, ... }: {
    programs.ghostty = {
      enable = true;
      systemd.enable = true;
    };
  };
}

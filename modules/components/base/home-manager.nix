{ inputs, lib, ... }:
{
  flake.modules.homeManager.base = { pkgs, config, configData, ... }:
  let
    username = configData.username;
  in
  {
    imports = [
      ./utilities.nix
    ];

    programs.home-manager.enable = true;

    home = {
      username = "${username}";
      homeDirectory = "/home/${username}";

      # pointerCursor = lib.mkIf conditions.graphicalUser {
      #   name = "BreezeX-RosePine-Linux";
      #   package = pkgs.rose-pine-cursor;
      #   size = 28;
      #   gtk.enable = true;
      # };

      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      stateVersion = "25.05";
    };

    programs.git = {
      enable = true;

      signing = {
        format = "ssh";
        key = "~/.ssh/id_ed25519_sk.pub";
      };

      settings = {
        user.name = "Thammachart";
        merge = {
          log = 100;
        };
        init = {
          defaultBranch = "main";
        };
      };

      includes = [
        { path = "${inputs.gitalias}/gitalias.txt"; }
      ];
    };

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };

    # home.sessionVariables doesn't load with nushell
    systemd.user.sessionVariables = lib.mkMerge [
      config.home.sessionVariables
      {}
    ];
  };
}

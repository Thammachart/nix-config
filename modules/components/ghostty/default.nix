{
  flake.modules.nixos.ghostty = { pkgs, ... }: {
    # environment.systemPackages = with pkgs; [ ghostty ];
  };

  flake.modules.homeManager.ghostty = { inputs, pkgs, config, configData, ... }:
  let
    s = configData.homeSettings;
  in
  {
    programs.ghostty = {
      enable = true;
      systemd.enable = true;

      clearDefaultKeybinds = true;

      settings = {
        theme = "Ayu";
        font-family = s.fonts.latin.terminal_monospace;
        font-size = 13;

        scrollback-limit = 5243000;

        shell-integration = "detect";

        quit-after-last-window-closed = false;
        # quit-after-last-window-closed-delay = "10m";

        keybind = [
          "ctrl+l=reset"
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"
        ];
      };
    };
  };
}

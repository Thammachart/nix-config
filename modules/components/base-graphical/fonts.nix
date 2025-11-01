{
  flake.modules.nixos.base-graphical = { pkgs, lib, configData, ... }:
  let
    fontConfigData = configData.homeSettings.fonts;
  in
  {
    fonts = {
      packages = with pkgs; [
        ## icon fonts
        material-design-icons

        ## normal fonts
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        inter
        liberation_ttf
        ubuntu-sans
        merriweather

        ## Monospace
        jetbrains-mono
        cascadia-code
        googlesans-code
        monaspace
        _0xproto
        geist-font
        martian-mono
        ubuntu-sans-mono
        lilex

        ## nerdfonts
        # nerd-fonts.caskaydia-mono
        nerd-fonts.geist-mono
        # nerd-fonts.monaspace
      ];

      fontDir = {
        enable = true;
      };

      # use fonts specified by user rather than default ones
      enableDefaultPackages = false;

      # user defined fonts
      # the reason there's Noto Color Emoji everywhere is to override DejaVu's
      # B&W emojis that would sometimes show instead of some Color emojis
      fontconfig = {
        enable = true;

        defaultFonts = {
          serif = ["Noto Serif" "Noto Serif Thai" "Noto Serif CJK JP" "Noto Color Emoji"];
          sansSerif = [fontConfigData.latin.ui fontConfigData.thai.ui "Ubuntu" "Noto Sans" "Noto Sans CJK JP" "Noto Color Emoji"];
          monospace = [fontConfigData.latin.ui_monospace fontConfigData.latin.terminal_monospace "JetBrainsMono NFP" "Noto Color Emoji"];
          emoji = ["Noto Color Emoji"];
        };

        antialias = true;
        hinting = lib.mkDefault {
          enable = false;
          style = "none";
        };

        localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <match target="pattern">
            <test name="family">
              <string>Segoe UI</string>
            </test>
            <edit binding="same" mode="assign" name="family">
              <string>system</string>
            </edit>
          </match>

          <match target="pattern">
            <test name="family">
              <string>Helvetica</string>
            </test>
            <edit binding="same" mode="assign" name="family">
              <string>system</string>
            </edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family">
              <string>Consolas</string>
            </test>
            <edit binding="same" mode="assign" name="family">
              <string>Cascadia Mono</string>
            </edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family">
              <string>Menlo</string>
            </test>
            <edit binding="same" mode="assign" name="family">
              <string>${fontConfigData.latin.ui_monospace}</string>
            </edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family">
              <string>system</string>
            </test>

            <edit name="family" mode="prepend" binding="strong">
              <string>${fontConfigData.latin.ui}</string>
              <string>Ubuntu Sans</string>
              <string>Liberation Sans</string>
            </edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family">
              <string>ui-monospace</string>
            </test>

            <edit name="family" mode="prepend" binding="strong">
              <string>${fontConfigData.latin.ui_monospace}</string>
            </edit>
          </match>

          <match target="font">
            <test name="family" compare="eq" ignore-blanks="true">
              <string>Inter Display</string>
            </test>
            <edit name="fontfeatures" mode="append">
            </edit>
          </match>

          <match target="font">
            <test name="family" compare="eq" ignore-blanks="true">
              <string>Martian</string>
            </test>
            <edit name="fontfeatures" mode="append">
              <string>ss03</string>
            </edit>
          </match>

          <match target="font">
            <test name="family" compare="contains" ignore-blanks="true">
              <string>Monaspace</string>
            </test>
            <edit name="fontfeatures" mode="append">
              <string>ss03</string>
              <string>ss04</string>
              <string>ss07</string>
              <string>liga</string>
              <string>calt</string>
            </edit>
          </match>
        </fontconfig>
        '';
      };
    };

  };
}

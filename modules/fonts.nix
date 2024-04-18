{ pkgs, pkgs-stable, config, ... }:
{
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      liberation_ttf
      ubuntu_font_family
      inter

      # nerdfonts
      (nerdfonts.override {fonts = ["CascadiaCode" "FiraCode" "JetBrainsMono"];})
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
        serif = ["Noto Serif" "Noto Serif CJK JP" "Noto Color Emoji"];
        sansSerif = ["Inter Display" "Ubuntu" "Noto Sans" "Noto Sans CJK JP" "Noto Color Emoji"];
        monospace = ["JetBrainsMono NFP" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };

      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
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
          <test qual="any" name="family">
            <string>Consolas</string>
          </test>
          <edit binding="same" mode="assign" name="family">
            <string>CaskaydiaCove NFP</string>
          </edit>
        </match>

        <match target="pattern">
          <test qual="any" name="family">
            <string>Menlo</string>
          </test>
          <edit binding="same" mode="assign" name="family">
            <string>JetBrainsMono NFP</string>
          </edit>
        </match>

        <match target="pattern">
          <test qual="any" name="family">
            <string>system</string>
          </test>

          <edit name="family" mode="prepend" binding="strong">
            <string>Inter Display</string>
            <string>Ubuntu</string>
            <string>Liberation Sans</string>
          </edit>
        </match>

        <match target="pattern">
          <test qual="any" name="family">
            <string>ui-monospace</string>
          </test>

          <edit name="family" mode="prepend" binding="strong">
            <string>JetBrainsMono NFP</string>
          </edit>
        </match>

        <match target="font">
          <test name="family" compare="eq" ignore-blanks="true">
            <string>Inter Display</string>
          </test>
          <edit name="fontfeatures" mode="append">
          </edit>
        </match>
      </fontconfig>
      '';
    };
  };
}
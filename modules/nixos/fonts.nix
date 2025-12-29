{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.whitesur.fonts.enable {
    fonts = {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-color-emoji
        fira-code
      ];

      fontconfig = {
        defaultFonts = {
          monospace = [ "Fira Code" ];
          sansSerif = [ "Noto Sans" ];
          serif = [ "Noto Serif" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
  };
}

{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.whitesur.gtk.enable {
    gtk = {
      enable = true;

      theme = {
        name = "WhiteSur-Dark";
        package = pkgs.whitesur-gtk-theme;
      };

      iconTheme = {
        name = "WhiteSur";
        package = pkgs.whitesur-icon-theme;
      };

      cursorTheme = {
        name = "capitaine-cursors";
        package = pkgs.capitaine-cursors;
      };

      font = {
        name = "Noto Sans";
        size = 11;
      };
    };
  };
}

{ lib, ... }:

{
  options.whitesur = {
    enable = lib.mkEnableOption "WhiteSur macOS-like theming in Home Manager";

    gnome.enable = lib.mkEnableOption "GNOME WhiteSur configuration" // { default = false; };

    gtk.enable = lib.mkEnableOption "GTK theme configuration" // { default = true; };
  };

  config = lib.mkIf config.whitesur.enable {
    imports = [
      (lib.mkIf config.whitesur.gtk.enable ./gtk.nix)
      (lib.mkIf config.whitesur.gnome.enable ./gnome.nix)
    ];
  };
}

{ config, lib, ... }:

{
  options.whitesur = {
    enable = lib.mkEnableOption "WhiteSur macOS-like theming in Home Manager";

    gnome.enable = lib.mkEnableOption "GNOME WhiteSur configuration" // { default = false; };

    gtk.enable = lib.mkEnableOption "GTK theme configuration" // { default = true; };
  };

  imports = [
    ./gtk.nix
    ./gnome.nix
  ];

  config = lib.mkIf config.whitesur.enable {};
}

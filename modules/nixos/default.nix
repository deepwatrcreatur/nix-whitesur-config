{ config, pkgs, lib, ... }:

{
  options.whitesur = {
    enable = lib.mkEnableOption "WhiteSur macOS-like theming";

    gnome.enable = lib.mkEnableOption "GNOME with WhiteSur theming" // { default = false; };

    fonts.enable = lib.mkEnableOption "WhiteSur fonts configuration" // { default = true; };

    cursor = lib.mkOption {
      type = lib.types.str;
      default = "White-cursor";
      description = "Cursor theme to use with WhiteSur";
    };

    cursorSize = lib.mkOption {
      type = lib.types.int;
      default = 24;
      description = "Cursor size in pixels";
    };

    iconTheme = lib.mkOption {
      type = lib.types.str;
      default = "WhiteSur";
      description = "Icon theme to use";
    };
  };

  config = lib.mkIf config.whitesur.enable {
    # Import submodules
    imports = [
      (lib.mkIf config.whitesur.fonts.enable ./fonts.nix)
      (lib.mkIf config.whitesur.gnome.enable ./gnome.nix)
    ];

    # Base packages for WhiteSur theming
    environment.systemPackages = with pkgs; [
      # WhiteSur macOS-like themes
      whitesur-gtk-theme
      whitesur-icon-theme

      # Cursor themes
      apple-cursor
      capitaine-cursors

      # Additional themes
      arc-theme
      adwaita-icon-theme

      # Dock application
      plank

      # Configuration tools
      dconf-editor
    ];

    # Environment variables for theme detection
    environment.variables = {
      ICON_THEME = config.whitesur.iconTheme;
      XCURSOR_THEME = config.whitesur.cursor;
      XCURSOR_SIZE = toString config.whitesur.cursorSize;
    };

    # Enable dconf for theme configuration
    programs.dconf.enable = true;
  };
}

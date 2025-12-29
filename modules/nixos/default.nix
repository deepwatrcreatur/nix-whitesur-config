{ config, pkgs, lib, ... }:

{
  options.whitesur = {
    enable = lib.mkEnableOption "WhiteSur macOS-like theming";

    gnome = {
      enable = lib.mkEnableOption "GNOME with WhiteSur theming" // { default = false; };

      autoRepeatDelay = lib.mkOption {
        type = lib.types.int;
        default = 300;
        description = "Keyboard autorepeat delay in milliseconds (useful for Proxmox guests)";
      };

      autoRepeatInterval = lib.mkOption {
        type = lib.types.int;
        default = 40;
        description = "Keyboard autorepeat interval in milliseconds";
      };

      wayland = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Wayland for GNOME (required for GNOME 49+)";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Username for auto-login (empty to disable)";
      };
    };

    fonts.enable = lib.mkEnableOption "WhiteSur fonts configuration" // { default = true; };

    cursor = lib.mkOption {
      type = lib.types.str;
      default = "White-cursor";
      description = "Cursor theme to use with WhiteSur";
    };

    cursorSize = lib.mkOption {
      type = lib.types.int;
      default = 50;
      description = "Cursor size in pixels";
    };

    iconTheme = lib.mkOption {
      type = lib.types.str;
      default = "WhiteSur";
      description = "Icon theme to use";
    };
  };

  imports = [
    ./fonts.nix
    ./gnome.nix
  ];

  config = lib.mkIf config.whitesur.enable {

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

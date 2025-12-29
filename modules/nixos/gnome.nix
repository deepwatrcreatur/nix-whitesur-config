{ config, pkgs, lib, ... }:

{
  options.whitesur.gnome = {
    enable = lib.mkEnableOption "GNOME with WhiteSur theming";

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

  config = lib.mkIf config.whitesur.gnome.enable {
    # Enable GNOME desktop environment
    services.xserver.enable = true;
    services.desktopManager.gnome.enable = true;

    # Configure keyboard autorepeat for VM guests
    services.xserver.autoRepeatDelay = config.whitesur.gnome.autoRepeatDelay;
    services.xserver.autoRepeatInterval = config.whitesur.gnome.autoRepeatInterval;

    # Display manager configuration
    services.displayManager.gdm = {
      enable = true;
      wayland = config.whitesur.gnome.wayland;
    };

    services.displayManager.defaultSession = "gnome";

    # Auto-login if user is specified
    services.displayManager.autoLogin = lib.mkIf (config.whitesur.gnome.user != "") {
      enable = true;
      user = config.whitesur.gnome.user;
    };

    # GNOME-specific packages
    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnome-shell-extensions
      deskflow  # For macOS clipboard sharing
      gnomeExtensions.dash-to-dock
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.blur-my-shell
      dconf-editor
    ];

    # XDG portals for better desktop integration
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
    };

    # Touchpad configuration for macOS-like gestures
    services.libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        clickMethod = "clickfinger";
      };
    };
  };
}

# nix-whitesur-config

A comprehensive NixOS flake for WhiteSur macOS-like theming with GNOME desktop environment support.

## Features

- **WhiteSur GTK Theme**: Complete macOS-like visual theme for GTK applications
- **GNOME Integration**: Full GNOME 49+ support with Wayland
- **Declarative Configuration**: Manage all theming through Nix modules
- **macOS-like Dock**: Floating dock on the right side using GNOME extensions
- **Customizable Options**: Theme colors, cursor size, fonts, and more
- **Cross-platform**: Works on both NixOS and macOS hosts

## Quick Start

### Using in Your NixOS Configuration

Add to your `flake.nix` inputs:

```nix
inputs = {
  nix-whitesur-config.url = "github:deepwatrcreatur/nix-whitesur-config";
  nix-whitesur-config.inputs.nixpkgs.follows = "nixpkgs";
};
```

Then import in your system configuration:

```nix
{ inputs, ... }:

{
  imports = [
    inputs.nix-whitesur-config.nixosModules.default
  ];

  whitesur = {
    enable = true;
    gnome.enable = true;
    gnome.user = "your-username";  # For auto-login
    fonts.enable = true;
  };
}
```

### For Home Manager

```nix
{ inputs, ... }:

home-manager.users.username = {
  imports = [
    inputs.nix-whitesur-config.homeManagerModules.gnome
  ];

  whitesur = {
    enable = true;
    gnome.enable = true;
    gtk.enable = true;
  };
};
```

## Configuration Options

### NixOS System Module

```nix
whitesur = {
  enable = true;                    # Enable WhiteSur theming
  gnome.enable = true;              # Enable GNOME with WhiteSur
  gnome.user = "username";          # Username for auto-login
  gnome.autoRepeatDelay = 300;      # Keyboard repeat delay (ms)
  gnome.autoRepeatInterval = 40;    # Keyboard repeat interval (ms)
  gnome.wayland = true;             # Use Wayland for GNOME 49+
  fonts.enable = true;              # Install WhiteSur fonts
  cursor = "White-cursor";          # Cursor theme
  cursorSize = 24;                  # Cursor size in pixels
  iconTheme = "WhiteSur";           # Icon theme
};
```

### Home Manager Module

```nix
whitesur = {
  enable = true;                    # Enable WhiteSur theming
  gnome.enable = true;              # Configure GNOME with WhiteSur
  gtk.enable = true;                # Configure GTK themes
};
```

## Module Structure

```
modules/
├── nixos/
│   ├── default.nix          # Main system module with options
│   ├── fonts.nix            # Font configuration
│   └── gnome.nix            # GNOME-specific configuration
└── home-manager/
    ├── default.nix          # Main Home Manager module
    ├── gtk.nix              # GTK theme configuration
    └── gnome.nix            # GNOME dconf settings and extensions
```

## Features

### GNOME Extensions

The flake automatically enables and configures:

- **dash-to-dock**: Floating macOS-like dock on the right edge
- **blur-my-shell**: Transparency effects for panel and dock
- **clipboard-indicator**: Enhanced clipboard management

### Theme Customization

Comprehensive dconf settings for:

- Window manager theme (WhiteSur-Dark)
- Icon theme (WhiteSur)
- Cursor theme (Capitaine cursors)
- Fonts (Noto Sans, Fira Code, Noto Serif)
- Shell extension configuration
- Desktop background settings

### Keyboard and Input

- Configurable keyboard repeat rates for VM guests
- macOS-like touchpad settings (natural scrolling, tapping)
- Click focus mode with right-button window resizing

## Development

The flake includes a development shell with:

- `nixpkgs-fmt` - Nix code formatter
- `statix` - Nix linter
- `nix-doc` - Nix documentation

Enter the dev shell:

```bash
nix flake show
nix develop
```

## License

MIT

## References

- [WhiteSur GTK Theme](https://github.com/vinceliuice/WhiteSur-gtk-theme)
- [GNOME Extensions](https://extensions.gnome.org/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)

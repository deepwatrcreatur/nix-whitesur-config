# WhiteSur Config Usage Guide

This guide covers how to use the nix-whitesur-config flake in your NixOS and Home Manager configurations.

## Installation

### Step 1: Add to Flake Inputs

In your `flake.nix`, add the whitesur-config as an input:

```nix
{
  inputs = {
    # ... other inputs ...
    nix-whitesur-config.url = "github:deepwatrcreatur/nix-whitesur-config";
    nix-whitesur-config.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-whitesur-config, ... }@inputs:
    # ... rest of your flake ...
}
```

### Step 2: Configure Your Host

In your NixOS host configuration:

```nix
# hosts/nixos/myhost/default.nix
{ inputs, config, ... }:

{
  imports = [
    inputs.nix-whitesur-config.nixosModules.default
  ];

  # Enable WhiteSur theming
  whitesur = {
    enable = true;
    gnome.enable = true;
    gnome.user = "myusername";
    fonts.enable = true;
  };
}
```

### Step 3: Configure Home Manager

In your Home Manager configuration:

```nix
# users/myuser/hosts/myhost/default.nix
{ inputs, ... }:

{
  imports = [
    inputs.nix-whitesur-config.homeManagerModules.gnome
  ];

  whitesur = {
    enable = true;
    gnome.enable = true;
    gtk.enable = true;
  };
}
```

## Common Configurations

### Basic GNOME with WhiteSur (No Auto-login)

```nix
whitesur = {
  enable = true;
  gnome.enable = true;
  fonts.enable = true;
};
```

### With Auto-login

```nix
whitesur = {
  enable = true;
  gnome = {
    enable = true;
    user = "deepwatrcreatur";
  };
  fonts.enable = true;
};
```

### For Proxmox VMs (With Keyboard Fix)

```nix
whitesur = {
  enable = true;
  gnome = {
    enable = true;
    user = "deepwatrcreatur";
    autoRepeatDelay = 300;
    autoRepeatInterval = 40;
  };
  fonts.enable = true;
};
```

### Disable Wayland (if needed)

```nix
whitesur = {
  enable = true;
  gnome = {
    enable = true;
    wayland = false;  # Force X11
  };
};
```

### Custom Cursor Configuration

```nix
whitesur = {
  enable = true;
  cursor = "capitaine-cursors";
  cursorSize = 32;
  iconTheme = "Adwaita";
};
```

## Customizing GNOME Settings

The Home Manager module provides full dconf settings for GNOME. You can override settings in your Home Manager configuration:

```nix
{ config, lib, ... }:

{
  imports = [
    inputs.nix-whitesur-config.homeManagerModules.gnome
  ];

  dconf.settings = {
    # Override WhiteSur dash-to-dock position
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";  # Move dock to bottom instead of right
      dock-fixed = true;
    };

    # Customize blur settings
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      sigma = 20;  # Increase blur amount
    };
  };
}
```

## Adjusting Font Size

To customize font sizes, add to your Home Manager config:

```nix
dconf.settings = {
  "org/gnome/desktop/interface" = {
    font-name = "Noto Sans 12";  # Larger fonts
  };
};
```

## Disabling Extensions

If you want to disable certain GNOME extensions:

```nix
dconf.settings = {
  "org/gnome/shell" = {
    enabled-extensions = [
      "dash-to-dock@micxgx.gmail.com"
      # Remove other extensions by not listing them
    ];
  };
};
```

## Troubleshooting

### Extensions Not Loading

Rebuild Home Manager and restart GNOME Shell:

```bash
home-manager switch
# Log out and back in, or press Alt+F2, type 'r', press Enter
```

### Theme Not Applied

Ensure both system module and Home Manager module are imported:

```nix
# In NixOS config
imports = [
  inputs.nix-whitesur-config.nixosModules.default
];

# In Home Manager config
imports = [
  inputs.nix-whitesur-config.homeManagerModules.gnome
];
```

### Dock Not Showing

Check if dash-to-dock extension is enabled:

```bash
gsettings get org.gnome.shell enabled-extensions
```

Should include `"dash-to-dock@micxgx.gmail.com"`.

### Cursor Not Changing

Verify cursor theme is installed:

```bash
ls -la ~/.icons/ | grep -i cursor
```

Or rebuild system to ensure packages are installed:

```bash
sudo nixos-rebuild switch
```

## Advanced: Using Only GTK Theme

If you want just the GTK theme without GNOME-specific settings:

```nix
imports = [
  inputs.nix-whitesur-config.homeManagerModules.gtk
];
```

This will configure GTK themes without loading GNOME dconf settings.

## Advanced: Custom Module

Create a wrapper module to apply your custom settings:

```nix
# modules/my-whitesur.nix
{ inputs, ... }:

{
  imports = [
    inputs.nix-whitesur-config.nixosModules.default
  ];

  whitesur = {
    enable = true;
    gnome = {
      enable = true;
      user = "myuser";
    };
  };

  # Your custom overrides
  environment.variables.MY_CUSTOM_VAR = "value";
}
```

## Rebuilding After Changes

After modifying your configuration:

```bash
# For NixOS
sudo nixos-rebuild switch --flake .#hostname

# For Home Manager only
home-manager switch --flake .#username@hostname
```

## See Also

- [WhiteSur GitHub](https://github.com/vinceliuice/WhiteSur-gtk-theme)
- [GNOME Extensions](https://extensions.gnome.org/)
- [NixOS Home Manager Manual](https://nix-community.github.io/home-manager/)

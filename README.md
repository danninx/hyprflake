# hyprflake

A helpful Home Manager module for the Hyprland ecosystem

## Overview

Configuring the Hyprland ecosystem can be somewhat repetitive, and becomes more complex when sharing dotfiles across multiple machines.

`hyprflake` attempts to address this issue by providing a structured and opinionated Home Manager module for the hyprland ecosystem.

## Features

- **Monitor configuration**: Declare monitor layouts in a clean attribute set
- **Opinionated workspace management**: Bind workspaces to monitors, and assign a primary display for workspaces to bind to

## Planned

- Ecosystem integration for things like `hyprpaper`, `hyprlock`, `hyprpanel`, etc.
- Documentation site and more expressive examples

## Installation

Add `hyprflake` as an input to your `flake.nix`, and then import the home manager module:
```nix
inputs = {
    hyprflake = {
        url = "github:danninx/hyprflake";
        inputs = {
            nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        }
    };
}
```

### Standalone Home Manager

```nix
Import the module into your `homeManagerConfiguration`:

homeConfigurations = {
  "your-user@your-host" = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      # 1. Import the hyprflake module
      hyprflake.homeManagerModules.default

      # 2. Your main configuration
      ./home.nix 
    ];
  };
};
```

### NixOS Module
Add the module to the `home-manager.sharedModules`:

```nix
home-manager.sharedModules = [ inputs.homeManagerModules.default ];
```

## Usage

```nix
{ config, pkgs, ... }:

{
    programs.hyprflake = {
        enable = true;

        monitors = {
            "DP-1" = {
                primary = true;
                resolution = { x = 2560; y = 1440; };
                refresh = 144;
                position = { x = 0; y = 0; };
                wallpaper = ./wallpapers/main.png;
            };

            "HDMI-A-1" = {
                resolution = { x = 1920; y = 1080; };
                position = {x = -1080; y = -240; };
                transform = 1;
                wallpaper = null;
            };
        };

        workspaces = {
            "1" = { monitor = "DP-1"; presistent = true; default = true; };
            "2" = { monitor = "DP-1"; presistent = true; };
            "3" = { monitor = "DP-1"; presistent = true; };
            "4" = { monitor = "DP-1"; presistent = true; };

            # 5 is assigned to the primary monitor. No workspaces remain unbound
            "5" = { persistent = true; }

            # hyprflake allows for more readable declaration of workspace rules
            "code" = { 
                monitor = "HDMI-A-1"; 
                special = true; 
                gapsin = 0;
                gapsout = 0;
                border = false;
                rounding = false;
                decorate = false;
                shadow = false;
            };

        };
    };
}
```

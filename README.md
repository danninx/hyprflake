# hyprflake

A Home Manager module for the Hyprland ecosystem

## Overview

Configuring the Hyprland ecosystem can be somewhat repetitive, and becomes more complex when sharing dotfiles across multiple machines.

`hyprflake` attempts to address this issue by providing a structured and opinionated Home Manager module for the hyprland ecosystem. The use of attribute sets for object configuration as well as assertions allows for some semantic checking to be done, and prevents repetitive definitions from occurring in a configuration.

## Features

- **Monitor configuration**: Declare monitor layouts in a clean attribute set
- **Opinionated workspace management**: Bind workspaces to monitors, configure a primary monitor unbound workspaces to bind to
- `hyprpaper` integration with Monitor configuration

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
                primary = true; # you must have a primary monitor
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

            # The "games" workspace is assigned to the primary monitor since no monitor was specified
            "games" = { 
                special = true;
                gapsin = 0;
                gapsout = 0;
                rounding = false;
            }

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

## Why not 'x'?

1. I'm a naive person
2. This really just came out of my dotfiles, so I probably wasn't aware of it at the time of creation

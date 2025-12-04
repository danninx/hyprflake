# hyprflake

A Home Manager helper-module for the Hyprland ecosystem

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
            "1" = { monitor = "DP-1"; persistent = true; default = true; };
            "2" = { monitor = "DP-1"; persistent = true; };
            "3" = { monitor = "DP-1"; persistent = true; };
            "4" = { monitor = "DP-1"; persistent = true; };

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

### Integration with existing dotfiles

This is what the module was really intended for. Say you have $n$ workspaces common across multiple machines (ex. the default "1, 2, 3, ... 9, 0" layout).
As is common for nix, you may choose to throw these into a module imported by your hosts, as well as some other special purpose workspaces.

```nix
# home/modules/hyprflake.nix
{ ... }:

let
    generalWorkspace = { persistent = true; };
in
    {
        programs.hyprflake.workspaces = {
           "1" = { persistent = true; };
           "2" = generalWorkspace;
           "3" = generalWorkspace;
           "4" = generalWorkspace;
           ...
    
           "discord" = {
                special = true;
           };
    
           "code" = {
                special = true;
                gapsin = 0;
                gapsout = 0;
                border = false;
                rounding = false;
                decorate = false;
                shadow = false;
           };
        }
    }
```

Now say perhaps your different machines have different monitor layouts (ex. a desktop with two monitors and a laptop, or a separate host with a vertical monitor), these workspaces would have to be redefined using the default `hyprland` module due to its usage of lists for multiple definitions:

```nix
# host1/home.nix
{
    workspaces = [
        ...
    ];
}

# host2/home.nix
{
    workspaces = [ # workspaces must be redefined here to change values
        ...
    ];
}
```

Since `hyprflake` uses attribute sets for definitions, this is prevented as common values can live in an imported module (ex. the `hyprflake.nix` shown previously), and then host-specific values may be defined as desired:

```nix
# host1/home.nix
{
    programs.hyprflake = {
        <monitor definitions>

        ...

        defaultMonitor = "DP-1";
        workspaces."code".monitor = "HDMI-A-1";
    }
}

# host2/home.nix
{
    programs.hyprflake = {
        <monitor definitions>

        ...

        defaultMonitor = "eDP-1";
    }
}
```

This is a much more idiomatic for home manager configuration, and prevents a lot of rewriting. Additionally, the use of attribute sets helps us to prevent multiple definitions, ensuring we are properly separating common values from home-specific ones:

```
error: The option `...` has conflicting definition values:
    - In `/home/modules/hyprflake.nix`
    - In `/hosts/host1/home.nix`
```

## Why not 'x'?

1. I'm a naive person
2. This really just came out of my dotfiles, so I probably wasn't aware of it at the time of creation

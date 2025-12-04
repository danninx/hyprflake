{
  lib,
  pkgs,
  ...
}: {
  programs.hyprflake = {
    enable = lib.mkEnableOption "configuration for Hyprland using hyprflake";

    monitors = lib.mkOption {
      type = lib.types.attrsOf (import ./types/monitor.nix {inherit lib;});
      description = ''
        An attribute set describing the monitors of the system.
        The key should be the port/name of the monitor, and the values are defined in types/monitor.nix.
        WARNING: `hyprflake` will NOT check if some settings for this monitor are valid, such as resolution and refresh rate.
      '';
      example = {
        "DP-1" = {
          primary = true;
          resolution = {
            x = 2560;
            y = 1440;
          };
          refresh = 144;
          position = {
            x = 0;
            y = 0;
          };
          scale = 1;
          wallpaper = ./images/wallpaper.jpg;
        };

        # A vertical monitor
        "HDMI-A-1" = {
          resolution = {
            x = 1920;
            y = 1080;
          };
          refresh = 60;
          position = {
            x = 0;
            y = 0;
          };
          scale = 1;
          transform = 1;
          # since no wallpaper is defined, this monitor will use the default background color
        };
      };
    };

    workspaces = lib.mkOption {
      types = lib.types.attrOf (import ./types/workspace.nix {inherit lib;});
      description = ''
        An attribute set describing the workspaces on this system.
        The key should be the name of the workspace, and the values are defined in types/workspace.nix.
        Values correspond to workspace rules applied to the workspace.
        For more information, see https://wiki.hypr.land/0.44.0/Configuring/Workspace-Rules/#rules
      '';
      example = {
        "coding" = {
          monitor = "HDMI-A-1";
          special = true;
          persistent = false;

          default = false;

          gapsin = 2;
          gapsout = 10;
          border = true;
          bordersize = 1;

          rounding = false;
          decorate = false;
          shadow = false;
        };
        "gaming" = {
          # since no monitor is set, this workspace will bind to the primary monitor
          gapsin = 2;
          gapsout = 10;
          border = true;
          bordersize = 1;

          rounding = false;
          decorate = false;
          shadow = false;
        };
      };
    };

    defaultWallpaper = lib.mkOption {
      types = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to an image to be used by the default monitor. Optional value used for replacing wallpapers on monitors with no wallpaper set.
      '';
      example = ./images/wallpaper.jpg;
    };

    defaultBackgroundColor = lib.mkOption {
      types = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Hex value of to color to be used as a default background color for monitors with no wallpaper.
        See https://wiki.hypr.land/0.44.0/Configuring/Variables/ for valid color schemes.
      '';
      example = "0x111111";
    };
  };
}

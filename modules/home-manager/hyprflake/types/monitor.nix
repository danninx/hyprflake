{lib, ...}:
lib.types.submodule {
  options = {
    primary = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Sets this monitor as the 'primary' monitor, which makes it the default monitor for workspace binding.
      '';
      example = true;
    };

    resolution = lib.mkOption {
      types = lib.types.submodule {
        options = {
          x = lib.mkOption {
            type = lib.types.int;
            default = 1920;
            description = ''
              X resolution size in pixels.
              See https://wiki.hypr.land/0.44.0/Configuring/Monitors/#general
            '';
          };
          y = lib.mkOption {
            type = lib.types.int;
            default = 1080;
            description = ''
              Y resolution size in pixels.
              See https://wiki.hypr.land/0.44.0/Configuring/Monitors/#general
            '';
          };
        };
      };

      default = { x = 1920; y = 1080; };
      description = ''Monitor resolution settings.'';
    };

    refresh = lib.mkOption {
      type = lib.types.int;
      default = 60;
      example = 144;
      description = ''
        Refresh rate for this monitor in Hz.
      '';
    };

    position = lib.mkOption {
      type = lib.types.submodule {
        options = {
          x = lib.mkOption {
            type = lib.types.int;
            default = 0;
            description = ''
              X position offset for monitor. Position is based on the top-left corner
              of the monitor. For more information see https://wiki.hypr.land/0.44.0/Configuring/Monitors/#general
            '';
          };
          y = lib.mkOption {
            type = lib.types.int;
            default = 0;
            description = ''
              Y position offset for monitor. Position is based on the top-left corner
              of the monitor. For more information see https://wiki.hypr.land/0.44.0/Configuring/Monitors/#general
            '';
          };
        };
      };
      default = { x = 0; y = 0; };
      description = ''Position of the monitor in pixels.'';
    };

    scale = lib.mkOption {
      type = lib.types.float;
      default = 1;
      description = ''
        Scale of monitor. See https://wiki.hypr.land/0.44.0/Configuring/Monitors/#general"
      '';
    };

    transform = lib.mkOption {
      type = lib.types.enum [
        0
        1
        2
        3
        4
        5
        6
        7
      ];
      default = 0;
      description = ''
        Transform of monitor, which determines its rotation.

        0 -> normal (no transforms)
        1 -> 90 degrees
        2 -> 180 degrees
        3 -> 270 degrees
        4 -> flipped
        5 -> flipped + 90 degrees
        6 -> flipped + 180 degrees
        7 -> flipped + 270 degrees

        See https://wiki.hypr.land/0.44.0/Configuring/Monitors/#rotating.
      '';
    };

    disabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether or not to disable a monitor, removing it from the layout.

        See https://wiki.hypr.land/0.44.0/Configuring/Monitors/#disabling-a-monitor
      '';
    };

    wallpaper = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = ''
        Path to the wallpaper image, which is used by hyprpaper for this monitor.
        The file is copied to the Nix store.
      '';
      default = null;
      example = "./wallpaper.png";
    };
  };
}

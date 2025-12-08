{lib, ...}:

# TODO finish this for general rules

let
  percentOrInt = lib.types.mkOptionType {
    name = "percentageOrInt";
    check = value:
    (
      lib.isInt value
      ) || (
        lib.types.isString value &&
        lib.strings.match "^[0-9]+%$" value != null
        );

        merge = lib.mergeOneOption;
        description = "An integer or string representing a percentage (e.g., '50%'). Percent values must also be an integer";
 };
in

lib.types.submodule {
  options = {
    float = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Float a window.
      '';
    };

    tile = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Tiles a window.
      '';
    };

    fullscreen = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Fullscreen a window.
      '';
    };

    maximize = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Maximizes a window.
      '';
    };

    fullscreenstate = lib.mkOption {
      type = lib.types.nullOr lib.types.submodule {
        options = {
          internal = lib.mkOption {
            type = lib.types.nullOr lib.types.enum [ "none" "maximize" "fullscreen" "maximize-fullscreen" ];
            default = null;
            example = "maximize";
          };

          client = lib.mkOption {
            type = lib.types.nullOr lib.types.enum [ "none" "maximize" "fullscreen" "maximize-fullscreen" ];
            default = null;
            example = "maximize";
          };
        };
      };
      default = null;
      example = {
        internal = "fullscreen";
        client = "maximize-fullscreen";
      };
      description = ''
        Sets the focused window's fullscreen mode and the one sent to the client.
      '';
    };

    # TODO this has a lot of options
    move = lib.mkOption {
      type = lib.types.nullOr lib.types.submodule {
        options = {
          anchor = lib.mkOption {
            type = lib.types.enum ["top-left" "bottom-right"];
            default = "top-left";
            example = "bottom-right";
            description = ''
              Helpful option for changing the anchor of a window. Bottom-right aligns the window to the bottom right and then subtracts the x or y value.
            '';
          };

          x = lib.mkOption {
            type = percentOrInt;
            default = 0;
            example = 50;
          };

          y = lib.mkOption {
            type = percentOrInt;
            default = 0;
            example = 50;
          };

          onscreen = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Force a window into the screen";
          };

          /*
          TODO
          subtractWidth = lib.mkOption {
            type = lib.types.bool;
          };
          */

          /*
          TODO - I'm not even sure what this means?
          cursor = lib.mkOption {
            type = lib.types.bool;
          };
          */
        };
      };
      default = null;
      description = ''
        Moves a floating window. Use bottom-right anchor to subtract from bottom-right corner of the screen.
      '';
      example = {
        x = "50%";
        y = "540";
        onscreen = true;
      };
    };

    size = lib.mkOption {
      type = lib.types.nullOr lib.types.submodule {
        options = {
          x = lib.mkOption {
            type = percentOrInt;
            default = "100%";
            example = "50%";
          };

          y = lib.mkOption {
            type = percentOrInt;
            default = "100%";
            example = "50%";
          };
        };
      };

      default = null;
      description = ''
        Resize a floating window
      '';
    };

    center = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Center a floating window on the monitor
      '';
    };
  };
}

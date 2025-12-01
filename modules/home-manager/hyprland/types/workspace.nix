{lib, ...}:
lib.types.submodule {
  options = {
    monitor = lib.mkOption {
      type = lib.nullOr lib.types.str; # TODO assertion: monitor must exist
      default = null;
      description = "Monitor to bind this workspace to. Monitor will not be bound if null.";
      example = "HDMI-A-1";
    };

    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this workspace should be the default workspace for the given monitor";
      example = true;
    };

    gapsIn = lib.mkOption {
      type = lib.nullOr lib.types.int;
      default = null;
      description = "Sets the gaps between windows, in pixels, for this workspace. Ignored if null.";
      example = 2;
    };

    gapsOut = lib.mkOption {
      type = lib.nullOr lib.types.int;
      default = null;
      description = "Sets the gaps between windows and monitor edges, in pixels, for this workspace. Ignored if null.";
      example = 5;
    };

    borderSize = lib.mkOption {
      type = lib.nullOr lib.types.int;
      default = null;
      descriptin = "Sets the border size around windows, in pixels, for this workspace. Ignored if null.";
      example = 1;
    };

    border = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to draw borders or not";
      example = true;
    };

    shadow = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to draw shadows or not";
      example = true;
    };

    rounding = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to draw rounded windows or not";
      example = true;
    };

    decorate = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to draw window decorations or not";
      example = true;
    };

    persistent = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Keep this workspace alive even if empty and inactive";
      example = true;
    };
  };
}

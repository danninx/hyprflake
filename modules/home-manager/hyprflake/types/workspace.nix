{
  config,
  lib,
  ...
}: let
  defaultMonitors = lib.attrNames (lib.filterAttrs (m: v: v.primary == true) config.programs.hyprflake.monitors);
  defaultMonitor =
    if lib.lists.length defaultMonitors == 0
    then null
    else lib.lists.head defaultMonitors;
  keySequence = import ./keySequence.nix {inherit config lib;};
  bindingType = import ./binding.nix {inherit config lib;};
  windowFieldsType = import ./windowFields.nix {inherit config lib;};
in
  lib.types.submodule {
    options = {
      monitor = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = defaultMonitor;
        description = "Monitor to bind this workspace to. Monitor will not be bound if null.";
        example = "HDMI-A-1";
      };

      default = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether this workspace should be the default workspace for the given monitor";
        example = true;
      };

      special = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether this workspace is a special workspace.";
      };

      gapsIn = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Sets the gaps between windows, in pixels, for this workspace. Ignored if null.";
        example = 2;
      };

      gapsOut = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Sets the gaps between windows and monitor edges, in pixels, for this workspace. Ignored if null.";
        example = 5;
      };

      borderSize = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Sets the border size around windows, in pixels, for this workspace. Ignored if null.";
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

      open = lib.mkOption {
        type = lib.types.nullOr keySequence;
        default = null;
        description = "Keybind sequence for opening the workspace";
        example = {
          mods = ["SUPER"];
          key = "1";
        };
      };

      moveWindow = lib.mkOption {
        type = lib.types.nullOr keySequence;
        default = null;
        description = "Keybind sequence for moving a window to the workspace";
        example = {
          mods = ["SUPER" "SHIFT"];
          key = "1";
        };
      };

      extraBindings = lib.mkOption {
        type = lib.types.listOf bindingType;
        default = [];
        description = "A list of keybinds associated with this workspace";
      };

      windowSelectors = lib.mkOption {
        type = lib.types.listOf windowFieldsType;
        default = [];
        description = "A list of window selectors. Windows matching any of these window selectors will default to the parent workspace.";
        example = [
          {
            class = "discord";
          }
        ];
      };
    };
  }

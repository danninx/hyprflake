{lib, ...}:
lib.types.submodule {
  options = {
    # class:[regex]
    class = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Regex to match window 'class'.";
      example = "^(kitty)$";
    };

    # title:[regex]
    title = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Regex to match window 'title'.";
      example = "^(kitty)$";
    };

    # initialClass:[regex]
    initialClass = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Regex to match window 'initialClass'.";
      example = "^(kitty)$";
    };

    # initialTitle:[regex]
    initialTitle = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Regex to match window 'initialTitle'.";
      example = "^(kitty)$";
    };

    # tag:[name]
    tag = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Match window using a 'tag'.";
      example = "dev";
    };

    # xwayland:[0/1]
    xwayland = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Match Xwayland windows (true for 1, false for 0).";
      example = true; # Corrected to Nix boolean
    };

    # floating:[0/1]
    floating = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Match floating windows (true for 1, false for 0).";
      example = true; # Corrected to Nix boolean
    };

    # fullscreen:[0/1]
    fullscreen = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Match fullscreen windows (true for 1, false for 0).";
      example = true; # Corrected to Nix boolean
    };

    # pinned:[0/1]
    pinned = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Match pinned windows (true for 1, false for 0).";
      example = true; # Corrected to Nix boolean
    };

    # focus:[0/1]
    focus = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Match the currently focused window (true for 1, false for 0).";
      example = true; # Corrected to Nix boolean
    };

    /*
    TODO: ?
    # fullscreenstate:[internal|client]
    fullscreenstate = lib.mkOption {
      type = lib.types.nullOr lib.types.enum [""];
      default = null;
      description = ''
        Windows with matching fullscreenstate. internal and client can be
        * - any, 0 - none, 1 - maximize, 2 - fullscreen, 3 - maximize and fullscreen.
      '';
      example = "internal:2";
    };
    */

    # workspace:[w]
    workspace = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Windows on matching workspace. 'w' can be 'id' or 'name:string'.";
      example = "id:1";
    };
  };
}

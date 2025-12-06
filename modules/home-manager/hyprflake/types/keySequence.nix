{lib, ...}:
lib.types.submodule {
  options = {
    mods = lib.mkOption {
      type =
        lib.types.listOf lib.types.str;

      default = [];
      description = ''
        A list of modkeys to be applied for this keybind.
        Use `wev` or a similar tool for determining modifiers.

        Standard mod-keys are:

        "SHIFT"
        "CAPS"
        "CTRL"
        "ALT"
        "MOD2"
        "MOD3"
        "SUPER"
        "MOD5"

        For other modifiers, see https://github.com/xkbcommon/libxkbcommon/blob/master/include/xkbcommon/xkbcommon-keysyms.h
      '';
      example = ["SUPER" "SHIFT"];
    };

    key = lib.mkOption {
      type = lib.types.str;
      example = "Q";
      description = ''
        Key to use. For uncommon keys, bind using a keycode by writing:
        code:[keycode]
      '';
    };
  };
}

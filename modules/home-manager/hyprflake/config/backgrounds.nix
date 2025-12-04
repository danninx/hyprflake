{
  config,
  lib,
  ...
}: let
  cfg = config.programs.hyprflake;
  hasWallpaper = lib.filterAttrs (m: v: v.wallpaper != null) cfg.monitors;
  preloaded = lib.lists.unique (lib.mapAttrsToList (m: v: toString v.wallpaper) hasWallpaper);
  defaultWallpaper = lib.defaultTo "none" (toString cfg.defaultWallpaper);
  mkWallpaper = port: config:
    if config.wallpaper == null
    then "${port}, ${defaultWallpaper}"
    else "${port}, ${toString config.wallpaper}";
  defaultBackground =
    if cfg.defaultBackgroundColor == null
    then {}
    else {
      disable_hyprland_logo = true;
      background_color = cfg.defaultBackgroundColor;
    };
in {
  config = lib. mkIf cfg.enable {
    # Wallpapers
    services.hyprpaper.settings = {
      preload = preloaded;
      wallpaper = lib.mapAttrsToList mkWallpaper cfg.monitors;
    };

    # Default color fallthrough
    wayland.windowManager.hyprland.settings.misc = defaultBackground;
  };
}

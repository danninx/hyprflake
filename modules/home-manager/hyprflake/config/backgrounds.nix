{
  cfg,
  lib,
  ...
}: let
  hasWallpaper = lib.lists.filter (m: m.wallpaper != null) cfg.monitors;
  preloaded = lib.lists.unique (lib.lists.forEach hasWallpaper (m: m.wallpaper));
  defaultWallpaper = lib.defaultTo "none" cfg.defaultWallpaper;
  mkWallpaper = port: config:
    if config.wallpaper == null
    then "${port}, ${defaultWallpaper}"
    else "${port}, ${config.wallpaper}";
  defaultBackground =
    if cfg.defaultBackgroundColor == null
    then {}
    else {
      disable_hyprland_logo = true;
      background_color = cfg.defaultBackgroundColor;
    };
in {
  config = {
    # Wallpapers
    services.hyprpaper.settings = {
      preload = preloaded;
      wallpaper = lib.mapAttrsToList mkWallpaper cfg.monitors;
    };

    # Default color fallthrough
    wayland.windowManager.hyprland.settings.misc = defaultBackground;
  };
}

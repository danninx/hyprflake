{
  cfg,
  lib,
  ...
}: let
  mkMonitor = port: config:
    port
    + lib.concatStrings [
      ", "
      (toString config.resolution.x)
      "x"
      (toString config.resolution.y)
      "@"
      (toString config.refresh)
      ", "
      (toString config.position.x)
      "x"
      (toString config.position.y)
      ", "
      (toString config.scale)
      ", "
      "transform, "
      (toString config.transform)
      (
        if config.disabled
        then ", disable"
        else ""
      )
    ];
in {
  assertions = [
    {
      assertion = let
        scales = lib.mapAttrsToList (name: value: value.scale) cfg.monitors;
      in
        lib.lists.all (scale: scale > 0.0) scales;
      message = "The scale of a monitor must be positive number";
    }
    {
      assertion = let
        primaries = lib.filterAttrs (n: v: v.primary == true) cfg.monitors;
      in (lib.length (lib.attrNames primaries) == 1);
      message = "You must set exactly one primary monitor";
    }
  ];

  config = {
    wayland.windowManager.hyprland.settings.monitor = lib.mapAttrsToList mkMonitor cfg.monitors;
  };
}

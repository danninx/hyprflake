{
  cfg,
  lib,
  ...
}: let
  mkWorkspace = name: config:
    lib.concatStrings [
      (
        if config.special
        then "special:"
        else ""
      )
      "${name}, "
      (
        if config.monitor != null
        then "monitor:${config.monitor}, "
        else ""
      )
      (
        if config.default
        then "default:true, "
        else ""
      )
      (
        if config.gapsIn != null
        then "gapsin:${config.gapsIn}, "
        else ""
      )
      (
        if config.gapsOut != null
        then "gapsout:${config.gapsOut}, "
        else ""
      )
      (
        if config.borderSize != null
        then "bordersize:${config.borderSize}, "
        else ""
      )
      (
        if config.border
        then ""
        else "border:false, "
      )
      (
        if config.shadow
        then ""
        else "shadow:false, "
      )
      (
        if config.rounding
        then ""
        else "rounding:false, "
      )
      (
        if config.decorate
        then ""
        else "decorate:false, "
      )
      (
        if config.persistent
        then "persistent:true"
        else ""
      )
    ];
in {
  assertions = [
    {
      assertion = let
        validMonitors = lib.attrNames cfg.monitors;
        boundMonitors = lib.mapAttrsToList (name: config: config.monitor) cfg.workspaces;
      in
        lib.lists.all (m: lib.lists.elem m validMonitors) boundMonitors;
      message = "workspace's monitor must be present in the configuration";
    }
  ];

  config = {
    wayland.windowManager.hyprland.settings.workspace = lib.mapAttrsToList mkWorkspace cfg.workspaces;
  };
}

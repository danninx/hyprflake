{
  cfg,
  lib,
  ...
}: let
  primaryMonitor = lib.headDef null (lib.flatten (lib.mapAttrsToList (port: config: lib.optional (config.primary) port)));
  mkWorkspace = name: config: let
    monitorName =
      if config.monitor != null
      then config.monitor
      else if primaryMonitor != null
      then primaryMonitor
      else null;
  in
    lib.concatStringsSep ", " (lib.flatten [
      (
        if config.special
        then "special:${name}"
        else name
      )
      (lib.optional (monitorName != null) "monitor:${monitorName}")
      (lib.optional config.default "default:true")
      (lib.optional (config.gapsIn != null) "gapsin:${config.gapsIn}")
      (lib.optional (config.gapsOut != null) "gapsout:${config.gapsOut}")
      (lib.optional (config.borderSize != null) "bordersize:${config.borderSize}")
      (lib.optional (!config.border) "border:false")
      (lib.optional (!config.shadow) "shadow:false")
      (lib.optional (!config.rounding) "rounding:false")
      (lib.optional (!config.decorate) "decorate:false")
      (lib.optional config.persistent "persistent:true")
    ]);
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

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.workspace = lib.mapAttrsToList mkWorkspace cfg.workspaces;
  };
}

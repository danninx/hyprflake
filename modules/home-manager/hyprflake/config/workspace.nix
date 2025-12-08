{
  config,
  lib,
  ...
}: let
  cfg = config.programs.hyprflake;
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
      "name:${toString name}"
      (
        if config.special
        then "special:${name}"
        else name
      )
      (lib.optional (monitorName != null) "monitor:${monitorName}")
      (lib.optional config.default "default:true")
      (lib.optional (config.gapsIn != null) "gapsin:${toString config.gapsIn}")
      (lib.optional (config.gapsOut != null) "gapsout:${toString config.gapsOut}")
      (lib.optional (config.borderSize != null) "bordersize:${toString config.borderSize}")
      (lib.optional (!config.border) "border:false")
      (lib.optional (!config.shadow) "shadow:false")
      (lib.optional (!config.rounding) "rounding:false")
      (lib.optional (!config.decorate) "decorate:false")
      (lib.optional config.persistent "persistent:true")
    ]);
  mkWorkspaceBinds = name: config: let
    modKeys = binding: lib.concatStringsSep " and " binding.mods;
    open =
      if config.special
      then "togglespecialworkspace, ${name}"
      else "workspace, name:${name}";
    move =
      if config.special
      then "movetoworkspace, special:${name}"
      else "movetoworkspace, name:${name}";
  in [
    (lib.optional (config.open != null) "${modKeys config.open}, ${config.open.key}, ${open}")
    (lib.optional (config.moveWindow != null) "${modKeys config.moveWindow}, ${config.moveWindow.key}, ${move}")
  ];

  mkWorkspaceSelectorRules = name: config: let
    selectors = config.windowSelectors;
    identifier =
      if config.special
      then "special:${name}"
      else "name:${name}";
    mkZeroOne = name: val:
      lib.optional (val != null) (
        if val
        then "${name}:1"
        else "${name}:0"
      );
    mkRule = fields:
      lib.concatStringsSep ", " (lib.flatten [
        "workspace ${identifier}"
        (lib.optional (fields.class != null) "class:${fields.class}")
        (lib.optional (fields.title != null) "title:${fields.title}")
        (lib.optional (fields.initialClass != null) "initialClass:${fields.initialClass}")
        (lib.optional (fields.initialTitle != null) "initialTitle:${fields.initialTitle}")
        (lib.optional (fields.tag != null) "tag:${fields.tag}")
        (mkZeroOne "xwayland" fields.xwayland)
        (mkZeroOne "floating" fields.floating)
        (mkZeroOne "pinned" fields.pinned)
        (mkZeroOne "focus" fields.focus)
        (lib.optional (fields.workspace != null) "workspace:${fields.workspace}")
        (lib.optional (fields.onWorkspace != null) "onworkspace:${fields.onWorkspace}")
      ]);
  in
    lib.map mkRule selectors;
in {
  config = lib.mkIf cfg.enable {
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

    wayland.windowManager.hyprland.settings.workspace = lib.mapAttrsToList mkWorkspace cfg.workspaces;
    wayland.windowManager.hyprland.settings.bind = lib.flatten (lib.mapAttrsToList mkWorkspaceBinds cfg.workspaces);
    wayland.windowManager.hyprland.settings.windowrulev2 = lib.flatten (lib.mapAttrsToList mkWorkspaceSelectorRules cfg.workspaces);
  };
}

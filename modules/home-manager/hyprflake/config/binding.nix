{
  config,
  lib,
  ...
}: let
  cfg = config.programs.hyprflake;
  bindFlags = binding:
    lib.concatStrings [
      "bind"
      (lib.optional (binding.locked) "l")
      (lib.optional (binding.released) "r")
      (lib.optional (binding.repeat) "e")
    ];
  modKeys = binding: lib.concatStringsSep " and " binding.mods;
  mkBinding = binding: "${(bindFlags binding)} = ${(modKeys binding)}, ${binding.key}, ${binding.dispatcher}";
  extraWorkspaceBindings = lib.lists.flatten (lib.mapAttrsToList (name: value: value.extraBindings)) cfg.workspaces;
  allBindings = lib.lists.map mkBinding extraWorkspaceBindings;
in {
  config = {
    wayland.windowManager.hyprland.extraConfig = lib.concatStringsSep "\n" allBindings;
  };
}

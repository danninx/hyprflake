{
  cfg,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./config/monitor.nix
    ./config/workspace.nix
  ];

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.enable = true;
    services.hyprpaper.enable = true;
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprflake;
in {
  options = import ./options.nix {inherit lib pkgs;};

  imports = [
    ./config/backgrounds.nix
    ./config/monitor.nix
    ./config/workspace.nix
  ];

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.enable = true;
    services.hyprpaper.enable = true;
  };
}

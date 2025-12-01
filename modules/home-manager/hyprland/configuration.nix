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
}

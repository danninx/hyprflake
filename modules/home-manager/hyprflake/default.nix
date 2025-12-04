{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprflake;
in {
  options = import ./options.nix {inherit lib pkgs;};
  config = import ./configuration.nix {inherit config lib pkgs cfg;};
}

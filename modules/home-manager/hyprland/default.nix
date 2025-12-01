{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprflake;
in {
  options = import ./options.nix {inherit lib pkgs;};
  config = lib.mkMerge [
    (import ./configuration.nix {
      inherit
        config
        lib
        pkgs
        cfg
        ;
    })
    {
      assertions = import ./assertions.nix {inherit cfg config lib;};
    }
  ];
}

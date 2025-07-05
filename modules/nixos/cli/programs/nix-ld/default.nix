{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.infinitas;
let
  cfg = config.cli.programs.nix-ld;
in
{

  options.cli.programs.nix-ld = {
    enable = mkBoolOpt false "Enable nix-ld CLI program.";
  };

  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;
  };
}

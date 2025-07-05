{
  config,
  lib,
  ...
}:
with lib;
with lib.infinitas;
let
  cfg = config.nixos.cli.programs.nh;
in
{
  options.cli.programs.nh = {
    enable = mkBoolOpt false "Enable nh CLI program.";
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 3d --keep 4";
      flake = "/home/${config.user.name}/infinitas";
    };
  };
}

{
  config,
  lib,
  ...
}:
with lib;
with lib.infinitas;
let
  cfg = config.infinitas.user;
in
{

  options.infinitas.user = {
    enable = mkOpt types.bool false "Whether to configure user";
    home = mkOpt (types.nullOr types.str) "/home/${cfg.name}" "Home directory of the user";
    name = mkOpt (types.nullOr types.str) config.snowfallorg.user.name "The name of the user";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.name != null;
          message = "infinitas.user.name must be set";
        }
      ];

      home = {
        homeDirectory = mkDefault cfg.home;
        username = mkDefault cfg.name;
      };
    }
  ]);
}

{
  config,
  lib,
  ...
}:
with lib;
with lib.infinitas;
let
  cfg = configs.cli.terminals.foot;
in
{
  options.cli.terminals.foot = with types; {
    enable = mkBoolOpt false "Whether to enable Foot terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;

      settings = {
        main = {
          shell = "zsh";
          pad = "24x24";
          selection-target = "clipboard";
        };

        scrollback = {
          lines = 7500;
        };
      };
    };
  };
}

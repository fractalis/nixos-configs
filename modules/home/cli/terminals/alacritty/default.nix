{
  config,
  lib,
  ...
}:
with lib;
with lib.infinitas;
let
  cfg = config.cli.terminals.alacritty;
in
{
  options.cli.terminals.alacritty = with types; {
    enable = mkBoolOpt false "Whether to enable Alacritty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;

      settings = {
        shell = {
          program = "zsh";
        };

        window = {
          padding = {
            x = 32;
            y = 32;
          };
          decorations = "full";
        };

        selection = {
          save_to_clipboard = true;
        };

        mouse_binding = [
          {
            mouse = "Middle";
            action = "paste";
          }
        ];

        env = {
          TERM = "xterm-256color";
        };
      };
    };
  };
}

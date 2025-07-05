{
  config,
  lib,
  ...
}:
with lib;
with lib.infinitas;
let
  cfg = configs.cli.terminals.ghostty;
in
{
  options.cli.terminals.ghostty = with types; {
    enable = mkBoolOpt false "Whether to enable Ghostty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        font-family = "${config.stylix.fonts.monospace.name}";
        command = "zsh";
        gtk-titlebar = true;
        gtk-tabs-location = "left";
        gtk-single-instance = true;
        font-size = 14;
        window-padding-x = 8;
        window-padding-y = 8;
        copy-on-select = "clipboard";
        cursor-style = "block";
        confirm-close-surface = false;
        keybind = [
          "ctrl+shift+plus=increase_font_size:1"
          "ctrl+shift+minus=increase_font_size:-1"
        ];
      };
    };
  };
}

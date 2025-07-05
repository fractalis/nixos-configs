{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.roles.common;
in
{
  options.roles.common = {
    enable = lib.mkEnableOption "Enable Common Role";
  };

  config = lib.mkIf cfg.enable {
    browsers.firefox.enable = true;

    system = {
      nix.enable = true;
    };

    cli = {
      terminals.foot.enable = true;
      terminals.ghostty.enable = true;
      shells.zsh.enable = true;
    };
  };
}

{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.roles.common;
in
{
  options.roles.common = {
    enable = mkEnableOption "Enable Common Set of Configurations";
  };

  config = mkIf cfg.enable {
    hardware = {
      networking.enable = true;
    };

    services = {
      ssh.enable = true;
    };

    system = {
      nix.enable = true;
      boot.enable = true;
      locale.enable = true;
    };

    styles.stylix.enable = true;
  };
}

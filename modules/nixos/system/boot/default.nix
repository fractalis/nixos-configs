{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.infinitas) mkBoolOpt;

  cfg = config.system.boot;
in
{
  options.system.boot = {
    enable = mkBoolOpt false "Whether to enable booting.";
    plymouth = mkBoolOpt false "Whether to enable Plymouth during boot.";
    secureBoot = mkBoolOpt false "Whether to enable Secure Boot.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        efibootmgr
        efitools
        efivar
        fwupd
      ]
      ++ lib.optionals cfg.secureBoot [ sbctl ];

    boot = {
      kernelParams = lib.optionals cfg.plymouth [
        "quiet"
        "splash"
        "loglevel=3"
        "udev.log_level=0"
      ];
      initrd.systemd.enable = true;

      loader = {
        efi = {
          canTouchEfiVariables = true;
        };

        systemd-boot = {
          enable = !cfg.secureBoot;
          configurationLimit = 20;
          editor = false;
        };
      };

      plymouth = {
        enable = cfg.plymouth;
      };
    };
  };
}

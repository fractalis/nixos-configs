{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.infinitas;
let
  cfg = config.system.locale;
in
{

  options.system.locale = with types; {
    enable = mkBoolOpt false "Whether to manage locale settings.";
  };

  config = mkIf cfg.enable {
    i18n = {
      defaultLocale = "en_US.UTF-8";
    };

    time.timeZone = "America/New_York";

    # Configure keymap in X11
    services.xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };

    # Configure keymap in console
    console.keyMap = "us";
  };
}

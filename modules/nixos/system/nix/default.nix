{
  config,
  lib,
  ...
}:
with lib;
with lib.infinitas; let
  cfg = config.system.nix;
in {

  options.system.nix = with types; {
    enable = mkBoolOpt false "Whether to manage nix configuration.";
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        trusted-users = ["@wheel", "root"];
        auto-optimise-store = lib.mkDefault true;
        use-xdg-base-directories = true;
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = true;
      };
    };
  };
}
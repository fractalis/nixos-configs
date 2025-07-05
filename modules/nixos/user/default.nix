{
  config,
  lib,
  ...
}:
with lib;
with lib.infinitas;
let
  cfg = config.user;
in
{

  options.user = with types; {
    name = mkOpt str "cosmatrexis" "The name of the user's account";
    initialPassword = mkOpt str "1" "The initial password to use";
    extraGroups = mkOpt (listOf str) [ ] "Additional groups to add the user to.";
    extraOptions = mkOpt attrs { } "Options passed to user.user.<name>.";
  };

  config = {
    users.mutableUsers = false;
    users.users.${cfg.name} = {
      isNormalUser = true;
      inherit (cfg) name initialPassword;
      home = "/home/${cfg.name}";
      group = "users";

      extraGroups = [
        "wheel"
        "audio"
        "sound"
        "video"
        "networkmanager"
        "input"
        "tty"
        "podman"
        "kvm"
        "docker"
        "libvirtd"
      ] ++ cfg.extraGroups;
    } // cfg.extraOptions;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}

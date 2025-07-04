{
  config,
  lib,
  ...
}:
with lib;
with lib.infinitas;
let
  cfg = config.services.openssh;
in
{
  options.services.ssh = with types; {
    enable = mkBoolOpt false "Enable SSH";
    authorizedKeys = mkOpt (listOf str) [ ] "The Public Keys to apply.";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ 22 ];

      settings = {
        PasswordAuthentication = false;
        StreamLocalBindUnlink = "yes";
        GatewayPorts = "clientspecified";
        PermitRootLogin = false;
      };
    };
  };
}

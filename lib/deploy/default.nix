{
  lib,
  inputs,
}:
let
  inherit (inputs) deploy-rs;
in
rec {
  ## Uses deploy-rs to create deployment configurations.
  ##
  ## ```nix
  ## mkDeploy {
  ##   inherit self;
  ##   overrides = {
  ##     host-name.system.sudo = "doas -u";
  ##   };
  ## }
  ## ```
  ##
  #@ { self: Flake, overrides: Attrs ? {} } ->: Attrs
  mkDeploy =
    {
      self,
      overrides ? { },
    }:
    let
      hosts = self.nixosConfigurations or { };
      names = builtins.attrNames hosts;
      nodes = lib.foldl (
        result: name:
        let
          host = hosts.${name};
          user = hosts.config.user.name or null;
          inherit (host.pkgs) system;
        in
        result
        // {
          ${name} = (overrides.${name} or { }) // {
            hostname = overrides.${name}.hostname or "${name}";
            profiles = (overrides.${name}.profiles or { }) // {
              system =
                (overrides.${name}.profiles.system or { })
                // {
                  path = deploy-rs.lib.${system}.activate.nixos host;
                }
                // lib.optionalAttrs (user != null) {
                  user = "root";
                  sshUser = user;
                }
                // lib.optionalAttrs (host.config.security.infinitas.doas.enable or false) {
                  sudo = "doas -u";
                };
            };
          };
        }
      ) { } names;
    in
    {
      inherit nodes;
    };
}

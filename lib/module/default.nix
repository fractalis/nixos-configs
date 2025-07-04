{ lib, ... }:
with lib;
rec {

  # Module Related Functions

  ## Create a NixOS module option.
  ##
  ## ```nix
  ## lib.mkOpt nixpkgs.lib.types.str "myOption" "default value" "Description of this option."
  ## ```
  ##
  #@ Type -> String -> Any -> String
  mkOpt =
    type: default: description:
    mkOption {
      inherit
        type
        default
        description
        ;
    };

  ## Create NixOS Module option w/o a description.
  ##
  ## ```nix
  ## lib.mkOpt` nixpkgs.lib.types.str "myOption" "default value"
  ## ```
  ##
  #@ Type -> String -> Any
  mkOpt' = type: default: mkOpt type default null;

  mkBoolOpt = mkOpt types.bool;

  mkBoolOpt' = mkOpt' types.bool;

  mkPackageOpt = mkOpt types.package;

  mkPackageOpt' = mkOpt' types.package;

  ## Quickly enable an option.
  ## ```nix
  ## services.myService = enabled // { ... };
  ## ```
  enabled = {
    enable = true;
  };

  ## Quickly disable an option.
  ## ```nix
  ## services.myService = disabled // { ... };
  ## ```
  disabled = {
    enable = false;
  };
}

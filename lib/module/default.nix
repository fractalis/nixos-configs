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
    type: optionName: defaultValue: description:
    mkOption {
      inherit
        type
        optionName
        defaultValue
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
  mkOpt' =
    type: optionName: defaultValue:
    mkOpt type optionName defaultValue null;

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

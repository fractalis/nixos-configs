{ pkgs, ... }:
{

  home.packages = with pkgs; [ ];

  roles = {
    common.enable = true;
  };

  infinitas.user = {
    enable = true;
    name = "cosmatrexis";
  };

  home.stateVersion = "25.05";
}

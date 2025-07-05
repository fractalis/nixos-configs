{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.styles.stylix;
in
{
  imports = with inputs; [
    stylix.homeModules.stylix
  ];

  options.styles.stylix = {
    enable = lib.mkEnableOption "Enable Stylix";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.space-mono
      open-sans
      dejavu-fonts
    ];

    stylix = {
      enable = true;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tarot.yaml";

      iconTheme = {
        enable = true;
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "lavender";
        };
        dark = "Papirus-Dark";
      };

      targets = {
        firefox = {
          firefoxGnomeTheme.enable = true;
          profileNames = [ "default" ];
        };
      };

      images = pkgs.infinitas.wallpapers.mushroom-purple;

      cursor = {
        name = "Sweet";
        package = pkgs.sweet;
        size = 24;
      };

      fonts = {
        sizes = {
          terminal = 14;
          applications = 12;
          popups = 10;
        };

        serif = {
          name = "DejaVu Serif";
          package = pkgs.dejavu-fonts;
        };

        sansSerif = {
          name = "DejaVu Sans";
          package = pkgs.dejavu-fonts;
        };

        monospace = {
          name = "Space Mono";
          package = pkgs.nerd-fonts.space-mono;
        };

        emoji = {
          package = pkgs.noto-fonts.emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}

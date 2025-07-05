{
  pkgs,
  lib,
  config,
  host,
  ...
}:
with lib;
with lib.infintias;
let
  cfg = configs.cli.shells.zsh;
in
{
  options.cli.shells.zsh = with lib.types; {
    enable = mkBoolOpt false "Whether to enable Zsh configuration";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletions = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      shellAliases = {
        ls = "ls --color=auto";
        ll = "ls -l --color=auto";
        la = "ls -la --color=auto";
        update = "sudo nixos-rebuild switch";
      };

      history.size = 10000;
      
      ohMyZsh = {
        enable = true;
        theme = "muse";
        plugins = [
          asdf
          autoenv
          branch
          colorize
          colored-man-pages
          common-aliases
          copyfile
          copypath
          direnv
          dirhistory
          docker
          docker-compose
          dotenv
          emoji
          extract
          git
          github
          gradle

        ];
      }
    };
  };
}

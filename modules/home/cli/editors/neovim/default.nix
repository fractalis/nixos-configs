{
  configs,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.infinitas;
let
  inherit (inputs.nixCats) utils;
  cfg = configs.cli.editors.neovim;
in
{
  imports = [
    inputs.nixCats.homeModule
  ];

  options.cli.editors.neovim = with lib.types; {
    enable = mkBoolOpt false "Whether to enable Neovim configuration";
  };

  config = mkIf cfg.enable {

    nixCats = {
      enable = true;
      nixpkgs_version = inputs.nixpkgs;

      addOverlays = [ (utils.standardPluginOverlay inputs) ];

      packageNames = [
        "regularCats"
        "nixCats"
      ];

      luaPath = "${./.}";

      categoryDefinitions.replace =
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          mkNvimPlugin,
          ...
        }@packageDef:
        {
          lspsAndRuntimeDeps = {
            general = with pkgs; [
              universal-ctags
              ripgrep
              fd
              stdenv.cc.cc
            ];
            css = with pkgs; [
              stylelint
              prettierd
              rustywind
              tailwindcss-language-server
            ];
            docker = with pkgs; [
              dockerfile-language-server-nodejs
              docker-compose-language-service
              hadolint
            ];
            html = with pkgs; [
              htmlhint
              rubypackages_3_4.htmlbeautifier
              htmx-lsp
              vscode-langservers-extracted
              svelte-language-server
            ];
            go = with pkgs; [
              go
              golangci-lint
              delve
              gopls
              go-tools
              gotools
              gotestsum
            ];
            json = with pkgs; [ nodePackages_latest.vscode-json-languageserver ];
            lua = with pkgs; [
              stylua
              luajitPackages.luacheck
              lua-language-server
            ];
            markdown = with pkgs; [
              marksman
              marksdownlint-cli2
            ];
            nix = with pkgs; [
              nixd
              nixfmt-rfc-style
              statix
              nix-doc
            ];
            python = with pkgs; [
              isort
              black
              pyright
            ];
            sql = with pkgs; [
              sqls
              sqlfluff
            ];
            terraform = with pkgs; [
              terraform
              terraform-lsp
              tflint
              tfsec
            ];
            toml = with pkgs; [ taplo ];
            templ = with pkgs; [ templ ];
            typescript = with pkgs; [
              typescript-language-server
              eslint
            ];
            yaml = with pkgs; [
              yamlfmt
              yamllint
              yaml-language-server
            ];
          };
          startupPlugins = {
            debug = with pkgs.vimPlugins; [ nvim-nio ];
            general = with pkgs.vimPlugins; {
              always = [
                lze
                lzeextras
                vim-repeat
                plenary-nvim
              ];
              extra = [
                oil-nvim
                Schemastore-nvim
                nvim-web-devicons
                auto-session
              ];
            };
            themer =
              with pkgs.vimPlugins;
              (builtins.getAttr (categories.colorscheme or "catppuccin") {
                "catppuccin" = catppuccin-nvim;
                "catppuccin-mocha" = catppuccin-nvim;
              });
          };
          optionalPlugins = {
            debug = with pkgs.vimPlugins; [
              nvim-dap
              pkgs.neovimPlugins.nvim-dap-view
              nvim-dap-go
              debugmaster-nvim
            ];
            test = with pkgs.vimPlugins; [
              neotest
              neotest-golang
              nvim-coverage
              vim-dotenv
            ];
            lint = with pkgs.vimPlugins; [ nvim-lint ];
            format = with pkgs.vimPlugins; [ conform-nvim ];
            neonixdev = with pkgs.vimPlugins; [ lazydev-nvim ];
            general = {
              ai = with pkgs.vimPlugins; [
                copilot-lua
                CopilotChat-nvim
                avante-nvim
                inputs.mcphub-nvim.packages.${pkgs.system}.default
              ];
              cmp = with pkgs.vimPlugins; [
                blink-cmp
                blink-compat
                blink-ripgrep-nvim
                blink-cmp-avante
                luasnip
                friendly-snippets
                lspkind-nvim
                (pkgs.neovimPlugins.cmp-dbee.overrideAttrs {
                  nvimSkipModule = [
                    "cmp-dbee.connection"
                    "cmp-dbee.source"
                  ];
                })
                pkgs.neovimPlugins.cmp-go-deep
                sqlite-lua
              ];
              treesitter = with pkgs.vimPlugins; [
                nvim-treesitter-textobjects
                nvim-treesitter-withAllGrammars
              ];
              telescope = with pkgs.vimPlugins; [
                telescope-fzf-native-nvim
                telescope-media-files-nvim
                telescope-ui-select-nvim
                telescope-nvim
              ];
              always = with pkgs.vimPlugins; [ nvim-lspconfig ];
              git = with pkgs.vimPlugins; [
                gitsigns-nvim
                diffview-nvim
                advanced-git-search-nvim
                neogit
                pkgs.neovimPlugins.webify-nvim
              ];
              diagnostics = with pkgs.vimPlugins; [ trouble-nvim ];
              editor = with pkgs.vimPlugins; [
                mini-nvim
                refactoring-nvim
                arrow-nvim
                vim-illuminate
                nvim-navic
                todo-comments-nvim
                grug-far-nvim
                smarty-splits-nvim
                yanky-nvim
                inc-rename-nvim
                snacks-nvim
                pkgs.neovimPlugins.gx-nvim
                pkgs.neovimPlugins.templ-goto-defintion
                pkgs.neovimPlugins.tiny-code-actions
                pkgs.neovimPlugins.inline-edit
              ];
              extra = with pkgs.vimPlugins; [
                fidget-nvim
                todo-comments-nvim
                undotree
                nvim-dbee
              ];
              notes = with pkgs.vimPlugins; [
                obsidian-nvim
              ];
              ui = with pkgs.vimPlugins; [
                indent-blankline-nvim
                lualine-nvim
                dropbar-nvim
                helpview-nvim
                tailwind-tools-nvim
              ];
            };
          };
        };

      packageDefinitions.replace = {
        nixCats =
          { pkgs, ... }:
          {
            settings = {
              wrapRc = true;
              suffix-path = true;
              suffix-LD = true;
              aliases = [ "nvim" ];
              configDirName = "nvim";
            };
            categories = {
              general = true;
              neonixdev = true;

              css = true;
              docker = true;
              html = true;
              ts = true;
              go = true;
              json = true;
              kotlin = true;
              lua = true;
              markdown = true;
              nix = true;
              python = true;
              rust = true;
              sql = true;
              terraform = true;
              toml = true;
              templ = true;
              typescript = true;

              ai = true;
              diagnostics = true;
              editor = true;
              debug = true;
              test = true;
              lint = true;
              format = true;
              git = true;
              ui = true;
              extra = true;

              lspDebugMode = false;
              themer = true;
              colorscheme = "catppuccin";
            };
            extra = {
              nixdExtras = {
                inherit (inputs) nixpkgs;
                flake-path = inputs.self;
              };
            };
          };

        regularCats =
          { pkgs, ... }:
          {
            settings = {
              wrapRc = false;
              suffix-path = true;
              suffix-LD = true;
              unwrappedCfgPath = "${config.home.homeDirectory}/infinitas/modules/home/cli/editors/neovim";
              configDirName = "nvim";
              neovim-unwrapped = inputs.neovim-nightly-overlay.packges.${pkgs.system}.neovim;
            };
            categories = {
              general = true;
              neonixdev = true;

              css = true;
              docker = true;
              html = true;
              ts = true;
              go = true;
              json = true;
              kotlin = true;
              lua = true;
              markdown = true;
              nix = true;
              python = true;
              rust = true;
              sql = true;
              terraform = true;
              toml = true;
              templ = true;
              typescript = true;

              ai = true;
              diagnostics = true;
              editor = true;
              debug = true;
              test = true;
              lint = true;
              format = true;
              git = true;
              ui = true;
              extra = true;

              lspDebugMode = false;
              themer = true;
              colorscheme = "catppuccin";
            };
            extra = {
              nixdExtras = {
                inherit (inputs) nixpkgs;
                flake-path = inputs.self;
              };
            };
          };
      };
    };
  };
}

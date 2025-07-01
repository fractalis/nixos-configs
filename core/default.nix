# Entry Point

{ }:

{
    nixosModules = rec {
        default = ../modules/nixos;

        publicModules = default;
        privateModules = ../modules/nixos/_private;

        infinitas = ../subprojects/infinitas/modules;
    };

    homeModules = rec {
        default = ../modules/home-manager;

        publicModules = default;
        privateModules = ../modules/home-manager/_private;
        infinitas = ../subprojects/infinitas/modules;

    };

    nixvimModules = rec {
        default = ../modules/nixvim;

        publicModules = default;
        privateModules = ../modules/nixvim/_private;
        infinitas = ../subprojects/infinitas/modules;
    };

    wrapperManagerModules = rec {
        default = ../modules/wrapper-manager;

        publicModules = default;
        privateModules = ../modules/wrapper-manager/_private;
        infinitas = ../subprojects/infinitas/modules;
    };

    flakeModules = {
        default = ../modules/flake-parts;
        baseSetupConfig = ../modules/flake-parts/profiles/infinitas-template.nix;
    };

    lib = ../lib;
    infinitasLib = ../subprojects/infinitas/lib;
}

{
  pkgs,
  lib,
  ...
}:
let
  images = builtins.attrValues (builtins.readDir ./wallpapers);
  mkWallpaper =
    name: src:
    let
      fileName = builtins.baseNameOf src;
      pkg = pkgs.stdenvNoCC.mkDerivation {
        inherit name src;

        dontUnpack = true;

        installPhase = ''
          cp $src $out
        '';

        passthru = { inherit fileName; };
      };
    in
    pkg;
  names = builtins.map (lib.snowfall.path.get-file-name-without-extension) images;
  wallpapers = lib.foldl (
    acc: image:
    let
      name = lib.snowfall.path.get-file-name-without-extension image;
    in
    acc // { "${name}" = mkWallpaper name (./wallpapers + "/${image}"); }
  ) { } images;
  installTarget = "$out/share/wallpapers";
  installWallpapers = builtins.mapAttrs (name: wallpaper: ''
    cp ${wallpaper} ${installTarget}/${wallpaper.fileName}
  '') wallpapers;
in
pkgs.stdenvNoCC.mkDerivation {
  name = "wallpapers";
  src = ./wallpapers;

  installPhase = ''
    mkdir -p ${installTarget}

    find * -type f -mindepth 0 -maxdepth 0 -exec cp ./{} ${installTarget}/{} ';'
  '';

  passthru = {
    inherit names;
  } // wallpapers;
}

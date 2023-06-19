{
  description =
    "Lilex Font Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      defaultPackage = pkgs.stdenv.mkDerivation {
        name = "lilex-font";
        version = "2.200";
        src = pkgs.fetchzip {
          url = "https://github.com/mishamyrt/Lilex/releases/download/2.200/Lilex.zip";
          sha256 = "sha256-MPQfqCMFMjcAlMos1o4bC+I+cvQYwr2TjI4Q03QeuaQ=";
          stripRoot = false;
        };
        installPhase = ''
          mkdir -p $out/share/fonts
          cp -R $src $out/share/fonts/opentype/
        '';
        meta = { description = "Lilex Font."; };
      };
    }
  );
}

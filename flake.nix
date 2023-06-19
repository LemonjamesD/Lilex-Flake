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
        src = builtins.fetchGit {
          url = "https://github.com/mishamyrt/Lilex";
          rev = "6de21bfa221564e8694f281c663f16ab93b76c33";
        };
        buildInputs = with pkgs; [
          python311Packages.setuptools
          ttfautohint
          gcc # build-essential
          libffi
          libgit2
        ];
        buildPhase = ''
          cd $src
          # make configure doesn't work bruh
        '';
        meta = { description = "Lilex Font."; };
      };
    }
  );
}

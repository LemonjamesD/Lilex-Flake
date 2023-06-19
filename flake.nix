{
  description =
    "Lilex Font Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    
    mach-nix.url = "github:davhau/mach-nix";
    mach-nix.inputs.pypi-deps-db.follows = "pypi-fetcher";
    pypi-fetcher.url = "github:DavHau/nix-pypi-fetcher-2";
  };

  outputs = { self, nixpkgs, flake-utils, mach-nix, pypi-fetcher }:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = nixpkgs.legacyPackages.${system};
      pythonEnv = mach-nix.lib.${system}.mkPython rec {
        python = "python311";
        requirements = ''
          fontmake==3.5.1
          cu2qu==1.6.7
          gftools==0.9.27
          glyphsLib==6.2.1
          arrrgs==2.0.0
          ruff==0.0.259
          pylint==2.17.1
          colored==1.4.4
          fontbakery[freetype]==0.8.11
        '';
      };
      features = "";
    in {
      defaultPackage = pkgs.stdenv.mkDerivation {
        name = "lilex-font";
        version = "2.200";
        src = builtins.fetchGit {
          url = "https://github.com/mishamyrt/Lilex";
          rev = "6de21bfa221564e8694f281c663f16ab93b76c33";
        };
        buildInputs = with pkgs; [
          pythonEnv
          ttfautohint
          gcc # build-essential
          libffi
          libgit2
        ];
        buildPhase = ''
          ln -s ${pkgs.bash}/bin/bash /bin/bash
          ln -s ${pkgs.coreutils}/bin/* /bin

          ./scripts/lilex.py --features "${features}" build
        '';
        installPhase = ''
          mkdir -p $out/share/fonts
          cp -R $src/Lilex $out/share/fonts/truetype/
        '';
        meta = { description = "Lilex Font."; };
      };
    }
  );
}

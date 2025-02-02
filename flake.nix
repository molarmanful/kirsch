{
  description = "A versatile bitmap font with an organic flair";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    bited-utils = {
      url = "github:molarmanful/bited-utils";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      bited-utils,
      ...
    }:

    let
      name = "kirsch";
      version = builtins.readFile ./VERSION;
    in

    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        bupkgs = bited-utils.packages.${system};
      in
      rec {

        packages =
          let
            build =
              o:
              pkgs.callPackage ./. (
                {
                  inherit version;
                  inherit (bupkgs) bited-build;
                }
                // o
              );
          in
          {
            ${name} = build { pname = name; };
            "${name}-nerd" = build {
              pname = "${name}-nerd";
              nerd = true;
            };
            "${name}-release" = build {
              pname = "${name}-release";
              nerd = true;
              release = true;
            };
            "${name}-img" = pkgs.callPackage ./img.nix {
              inherit (bupkgs) bited-img;
              name = "${name}-img";
            };
            default = packages.${name};
          };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nil
            nixd
            nixfmt-rfc-style
            statix
            deadnix
            marksman
            markdownlint-cli
            actionlint
            taplo
            bupkgs.bited-clr
          ];
        };

      }
    );
}

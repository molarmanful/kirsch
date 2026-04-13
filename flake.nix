{
  description = "A versatile bitmap font with an organic flair";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    bited-utils = {
      url = "github:molarmanful/bited-utils";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.bited-utils.flakeModule ];
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          bited-utils = {
            name = "kirsch";
            version = builtins.readFile ./VERSION;
            src = ./.;
            nerd = true;

            buildTransformer =
              build:
              build.overrideAttrs {
                preBuild = ''
                  mkdir -p tmp
                  ${config.bited-utils.bited-bbl}/bin/bited-bbl --name 'kirsch Propo' --nerd --ceil < src/kirsch.bdf > tmp/kirsch_propo.bdf
                '';
              };
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              config.bited-utils.bited-clr
              taplo
              # lsps
              nil
              marksman
              # formatters
              nixfmt
              mdformat
              yamlfmt
              python3Packages.mdformat-gfm
              python3Packages.mdformat-gfm-alerts
              # linters
              statix
              deadnix
              actionlint
            ];
          };
        };
    };
}

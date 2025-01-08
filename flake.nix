{
  description = "A versatile bitmap font with an organic flair";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    bited-utils.url = "github:molarmanful/bited-utils";
  };

  outputs =
    {
      nixpkgs,
      utils,
      bited-utils,
      ...
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        f_kirsch =
          {
            nerd ? false,
            release ? false,
          }:
          pkgs.stdenvNoCC.mkDerivation {
            name = "kirsch";
            src = ./.;

            nativeBuildInputs = [ bited-utils.packages.${system}.bited-build ];

            buildPhase = ''
              runHook preBuild
              rm -rf out
              mkdir -p out
              bited-build src/kirsch.bdf out \
                ${pkgs.lib.optionalString nerd "--nerd"} \
                ${pkgs.lib.optionalString release "--release"}
              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall
              cp -r out/. $out
              runHook postInstall
            '';
          };

        kirsch-img = pkgs.writeShellApplication {
          name = "kirsch-img";

          runtimeInputs = [ bited-utils.packages.${system}.bited-img ];

          text = ''
            bited-img src/kirsch.bdf
          '';
        };

        kirsch = f_kirsch { };
        kirsch-nerd = f_kirsch { nerd = true; };
        kirsch-release = f_kirsch {
          nerd = true;
          release = true;
        };

      in
      {

        devShell = pkgs.mkShell {
          packages = with pkgs; [
            nil
            nixd
            nixfmt-rfc-style
            statix
            deadnix
            nushell
            marksman
            markdownlint-cli
            actionlint
            yamlfix
          ];
        };

        packages = {
          inherit
            kirsch
            kirsch-nerd
            kirsch-release
            kirsch-img
            ;
          default = kirsch;
        };
      }
    );
}

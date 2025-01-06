{
  description = "A versatile bitmap font with an organic flair";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    bitsnpicas-src = {
      url = "github:kreativekorp/bitsnpicas?dir=main/java/BitsNPicas";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
      bitsnpicas-src,
      ...
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        bitsnpicas = pkgs.stdenvNoCC.mkDerivation {
          name = "bitsnpicas";
          src = bitsnpicas-src;

          nativeBuildInputs = with pkgs; [
            temurin-bin
            makeWrapper
          ];

          preBuild = ''
            cd main/java/BitsNPicas
          '';

          buildFlags = "BitsNPicas.jar";

          installPhase = ''
            runHook preInstall
            mkdir -p $out/share/java $out/bin
            cp BitsNPicas.jar $out/share/java
            makeWrapper ${pkgs.temurin-jre-bin}/bin/java $out/bin/bitsnpicas \
              --add-flags "-jar $out/share/java/BitsNPicas.jar"
            runHook postInstall
          '';
        };

        f_kirsch =
          {
            nerd ? false,
            release ? false,
          }:
          pkgs.stdenvNoCC.mkDerivation {
            name = "kirsch";
            src = ./.;

            nativeBuildInputs =
              with pkgs;
              [
                bitsnpicas
                fontforge
                bdfresize
                xorg.bdftopcf
                woff2
                nushell
              ]
              ++ (if nerd then [ nerd-font-patcher ] else [ ])
              ++ (
                if release then
                  [
                    zip
                    pnpm
                  ]
                else
                  [ ]
              );

            buildPhase = ''
              runHook preBuild
              rm -rf out
              mkdir -p out
              nu main.nu src/kirsch.bdf out \
                ${if nerd then "--nerd" else ""} \
                ${if release then "--release" else ""}
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

          runtimeInputs = with pkgs; [
            bitsnpicas
            imagemagick
            nushell
          ];

          text = ''
            nu img.nu
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
            bitsnpicas
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

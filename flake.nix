{
  description = "A versatile bitmap font with an organic flair";

  inputs = {
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

            mkdir -p $out/share/java
            cp BitsNPicas.jar $out/share/java

            mkdir -p $out/bin
            makeWrapper ${pkgs.temurin-jre-bin}/bin/java $out/bin/bitsnpicas \
              --add-flags "-jar $out/share/java/BitsNPicas.jar"

            runHook postInstall
          '';
        };

        kirsch = pkgs.stdenvNoCC.mkDerivation {
          name = "kirsch";
          src = ./.;

          nativeBuildInputs = with pkgs; [
            bitsnpicas
            fontforge
            bdfresize
            xorg.bdftopcf
            woff2
            nerd-font-patcher
            nushell
          ];

          buildPhase = ''
            runHook preBuild

            nu main.nu

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            cp -r out/. $out

            runHook postInstall
          '';
        };

      in
      {

        devShell = pkgs.mkShell {
          packages = with pkgs; [
            bash-language-server # FIXME: remove
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
          inherit bitsnpicas kirsch;
          default = kirsch;
        };
      }
    );
}

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
      in
      {

        devShell = pkgs.mkShell {
          packages = with pkgs; [
            # FIXME: remove shell pkgs if converting build to nix
            bash-language-server
            shfmt
            shellharden
            marksman
            markdownlint-cli
            actionlint
            yamlfix
          ];
        };

        packages.bitsnpicas = pkgs.stdenvNoCC.mkDerivation {
          name = "bitsnpicas";
          src = bitsnpicas-src;

          nativeBuildInputs = with pkgs; [
            jdk
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
            makeWrapper ${pkgs.jre_minimal}/bin/java $out/bin/bitsnpicas \
              --add-flags "-jar $out/share/java/BitsNPicas.jar"

            runHook postInstall
          '';
        };

      }
    );
}

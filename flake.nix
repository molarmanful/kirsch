{
  description = "A versatile bitmap font with an organic flair";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    bited-utils.url = "github:molarmanful/bited-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
      bited-utils,
      ...
    }:

    let
      pname = "kirsch";
      version = self.shortRev or self.dirtyShortRev;
    in

    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              bited-utils = bited-utils.packages.${system};
            })
          ];
        };
        font_pkgs = {

          ${pname} = pkgs.callPackage ./. {
            inherit pname version;
          };

          "${pname}-nerd" = pkgs.callPackage ./. {
            inherit version;
            pname = "${pname}-nerd";
            nerd = true;
          };

          "${pname}-release" = pkgs.callPackage ./. {
            inherit version;
            pname = "${pname}-nerd";
            nerd = true;
            release = true;
          };

          "${pname}-img" = pkgs.writeShellApplication {
            inherit version;
            pname = "${pname}-img";
            text = "${bited-utils.bited-img}/bin/bited-img src/${pname}.bdf";
          };

        };
      in
      {

        packages = font_pkgs // {
          default = font_pkgs.${pname};
        };

        devShell = pkgs.mkShell {
          packages = with pkgs; [
            nil
            nixd
            nixfmt-rfc-style
            statix
            deadnix
            marksman
            markdownlint-cli
            actionlint
            yamlfix
          ];
        };

      }
    );
}

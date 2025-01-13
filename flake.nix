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

    let
      name = "kirsch";
      version = builtins.readFile ./VERSION;
      bdf = "src/kirsch.bdf";
    in

    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ bited-utils.overlay ];
        };
        build = o: pkgs.callPackage ./. ({ inherit version bdf; } // o);
      in
      {

        packages = rec {
          kirsch = build { pname = name; };
          kirsch-nerd = build {
            pname = "${name}-nerd";
            nerd = true;
          };
          kirsch-release = build {
            pname = "${name}-release";
            nerd = true;
            release = true;
          };
          kirsch-img = pkgs.callPackage ./img.nix {
            inherit bdf;
            name = "${name}-img";
          };
          default = kirsch;
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

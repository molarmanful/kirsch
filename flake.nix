{
  description = "A versatile bitmap font with an organic flair";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    bited-utils = {
      url = "github:molarmanful/bited-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      name = "kirsch";
      version = builtins.readFile ./VERSION;
    in

    {
      overlays.default =
        final: prev:
        let
          build = o: final.callPackage ./. ({ inherit version; } // o);
        in
        {
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
          kirsch-img = final.callPackage ./img.nix {
            name = "${name}-img";
          };
        };
    }

    // utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.appendOverlays [
          bited-utils.overlays.default
          self.overlays.default
        ];
      in
      {

        packages = {
          inherit (pkgs)
            kirsch
            kirsch-nerd
            kirsch-release
            kirsch-img
            ;
          default = pkgs.kirsch;
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
          ];
        };

      }
    );
}

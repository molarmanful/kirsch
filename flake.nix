{
  description = "A versatile bitmap font with an organic flair";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
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
    inputs@{ systems, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.bited-utils.flakeModule
      ];
      systems = import systems;
      perSystem =
        { config, pkgs, self', ... }:
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
	    packages = builtins.attrValues {
	      inherit (pkgs) nil nixd nixfmt-rfc-style statix deadnix taplo marksman mdformat;
	      inherit (pkgs.python3Packages) mdformat-gfm mdformat-gfm-alerts;
	      inherit (config.bited-utils) bited-clr;
	    };
	    shellHook = ''
	      echo -e "\e[31m"
	      ${builtins.concatStringsSep "\n" [
		"echo 'welcome to the development shell!\n'"
		"echo 'general commands: taplo bited-clr'"
		"echo 'lsps: marksman nixd nil'"
		"echo 'formatters: nixfmt-rfc-style mdformat'"
		"echo 'linters: statix deadnix'"
	      ]}
              echo -e "\e[0m"
	    '';
          };

	  formatter = pkgs.writeShellApplication {
	    name = "linter";
	    runtimeInputs = self'.devShells.default.nativeBuildInputs;
	    text = ''
	      find . -iname "*.nix" -exec nixfmt {} + \; -exec deadnix -e {} + \; -exec statix fix {} \;
              find . -iname "*.md" -exec mdformat {} + \;
	    '';
	  };
        };
    };
}

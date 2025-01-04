{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    bitsnpicas = {
      url = "github:kreativekorp/bitsnpicas";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
      bitsnpicas,
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
      }
    );
}

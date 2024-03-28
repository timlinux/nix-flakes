{
  description = "Tim NixOS Flakes";

  inputs = {
    nixpkgs.url = "nixpkgs"; # Resolves to github:NixOS/nixpkgs
    # Helpers for system-specific outputs
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    # Create system-specific outputs for the standard Nix systems
    # https://github.com/numtide/flake-utils/blob/master/default.nix#L3-L9
    flake-utils.lib.eachDefaultSystem (system:
      let
      	pkgs = import nixpkgs { inherit system; };
      in
      {
        # A simple executable package
        packages.default = pkgs.writeScriptBin "runme" ''
          echo "I am currently being run!"
        '';

        # An app that uses the `runme` package
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.runme}/bin/runme";
        };
      });
}

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, crane }:
    flake-utils.lib.eachDefaultSystem (system: let

      pkgs = import nixpkgs { inherit system; };
      craneLib = crane.lib.${system};

      package = pkgs.callPackage ./package.nix { inherit craneLib; };

    in {
      packages.default = package;
      devShells.default = pkgs.mkShell {
        inputsFrom = [
          package
        ];
      };
    }) # eachDefaultSystem
  ; # outputs
}

{
  #description = "Coursework for UCCS, CHEM 4731, FA2023";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    poetry2nix
  }:
    flake-utils.lib.eachDefaultSystem (system: let

      inherit (poetry2nix.legacyPackages.${system}) mkPoetryApplication;
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      packages = {
        myapp = mkPoetryApplication { projectDir = self; };
        default = self.packages.${system}.myapp;
      };

      devShells.default = pkgs.mkShell {
        packages = [ poetry2nix.packages.${system}.poetry ];
      };
    });
}
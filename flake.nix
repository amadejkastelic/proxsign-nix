{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          proxsign = pkgs.callPackage (if pkgs.stdenv.isDarwin then ./darwin.nix else ./default.nix) { };
          default = self.packages.${system}.proxsign;
        };
      }
    );
}

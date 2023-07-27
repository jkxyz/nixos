{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";
  };

  outputs = inputs@{ nixpkgs, nixos-hardware, nixpkgs-mozilla, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in {
      devShell.x86_64-linux =
        pkgs.mkShell { nativeBuildInputs = [ pkgs.nvd pkgs.babashka ]; };

      packages.x86_64-linux = {
        # These packages can be installed into a profile with `nix profile install .#PKG`
        pianoteq = pkgs.callPackage (import ./pkgs/pianoteq.nix) { };
        beeper = pkgs.callPackage (import ./pkgs/beeper.nix) { };
        vcv-rack = pkgs.callPackage (import ./pkgs/vcv-rack.nix) { };

        firefox-nightly-bin = let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ nixpkgs-mozilla.overlays.firefox ];
          };
        in pkgs.latest.firefox-nightly-bin;
      };

      nixosConfigurations = {
        sparrowhawk = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos
            ./modules/hosts/sparrowhawk.nix
            ./modules/home-manager.nix
            ./modules/home.nix
          ];
        };
      };
    };
}

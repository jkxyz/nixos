{
  description = "Nix systems configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixos-hardware
    , nixpkgs-mozilla, ... }:
    let pkgs = import nixpkgs { system = "x86_64-linux"; };
    in {
      devShell.x86_64-linux =
        pkgs.mkShell { buildInputs = [ pkgs.nvd pkgs.babashka ]; };

      packages.x86_64-linux =
        let pkgs = import nixpkgs { system = "x86_64-linux"; };
        in {
          pianoteq = pkgs.callPackage (import ./pianoteq.nix) { };

          vcv-rack = pkgs.callPackage (import ./vcv-rack.nix) { };

          beeper = pkgs.callPackage (import ./beeper.nix) { };

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
            nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
            ({ ... }: {
              nixpkgs.overlays = [
                (final: prev: {
                  unstable = import nixpkgs-unstable {
                    system = prev.system;
                    config.allowUnfree = true;
                  };
                })
              ];
            })
            ./modules/hosts/sparrowhawk.nix
            ./modules/nix-flakes.nix
            ./modules/home-manager.nix
            ./modules/home.nix
          ];
        };
      };
    };
}

{
  description = "Nix systems configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-emacs.url = "github:nixos/nixpkgs?rev=c90c4025bb6e0c4eaf438128a3b2640314b1c58d";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixpkgs-emacs
    , nixos-hardware, ... }:
    let pkgs = import nixpkgs { system = "x86_64-linux"; };
    in {
      devShell.x86_64-linux =
        pkgs.mkShell { buildInputs = [ pkgs.nvd pkgs.babashka ]; };
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

                  emacs = import nixpkgs-emacs { system = prev.system; };
                })
              ];
            })
            ./modules/hosts/sparrowhawk.nix
            ./modules/nix-flakes.nix
            ./modules/home-manager.nix
            # ./modules/emacs-overlay.nix
            ./modules/home.nix
          ];
        };
      };
    };
}

{
  description = "Nix systems configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    emacs-overlay.url = "path:./flakes/emacs-overlay";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixos-hardware
    , emacs-overlay, ... }:
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

                  emacs-overlay = emacs-overlay.packages.${prev.system};
                })
              ];
            })
            ./modules/hosts/sparrowhawk.nix
            ./modules/nix-flakes.nix
            ./modules/home-manager.nix
            ./modules/emacs-overlay.nix
            ./modules/home.nix
          ];
        };
      };
    };
}

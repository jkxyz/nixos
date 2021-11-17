{
  description = "Nix systems configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, ... }: {
    nixosConfigurations = {
      sparrowhawk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
          ./modules/hosts/sparrowhawk.nix
          ./modules/nix-flakes.nix
          ./modules/home-manager.nix
          # Not using latest Emacs yet due to issue in Doom
          # ./modules/emacs-overlay.nix
          ./modules/home.nix
        ];
      };
    };
  };
}

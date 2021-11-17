{
  description = "Nix systems configuration";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:nixos/nixos-hardware;
    emacs-overlay.url = github:nix-community/emacs-overlay;
    home-manager.url = github:nix-community/home-manager;
  };

  outputs = { self, nixpkgs, nixos-hardware, emacs-overlay, home-manager, ... }: {
    nixosConfigurations = {
      sparrowhawk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel 
          ./modules/hosts/sparrowhawk 
          ./modules/nix-unstable.nix
          (import ./modules/home-manager.nix home-manager)
          (import ./modules/emacs.nix emacs-overlay)
        ];
      };
    };
  };
}

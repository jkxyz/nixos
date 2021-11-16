{
  description = "Nix systems configuration";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-21.05;
    nixpkgs-unstable.url = github:nixos/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:nixos/nixos-hardware;
  };

  outputs = { nixpkgs, nixpkgs-unstable, nixos-hardware, ... }: {
    nixosConfigurations = {
      sparrowhawk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel 
          ./modules/hosts/sparrowhawk 
          ./modules/nix-unstable.nix
          (import ./modules/1password.nix nixpkgs-unstable)
        ];
      };
    };
  };
}

{
  description = "Nix systems configuration";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:nixos/nixos-hardware;
  };

  outputs = { nixpkgs, nixos-hardware, ... }: {
    nixosConfigurations = {
      sparrowhawk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./hosts/sparrowhawk 
          nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel 
        ];
      };
    };
  };
}

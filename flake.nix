{
  description = "Nix systems configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { nixpkgs, ... }: {
    nixosConfigurations = {
      sparrowhawk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/sparrowhawk ];
      };
    };
  };
}

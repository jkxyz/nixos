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
        # ThinkPad E14 laptop
        sparrowhawk = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos
            ./hosts/sparrowhawk
            ./modules/home-manager.nix
            ./modules/home.nix
          ];
        };

        # MacBook Pro 2017 home server
        radagast = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./nixos/unstable.nix ./hosts/radagast ];
        };

        # Custom NixOS installation media with proprietary broadcom wifi drivers
        # Build with nix build .#nixosConfigurations.config.system.build.isoImage
        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ({ config, pkgs, ... }: {
              imports = [
                "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
                "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
              ];

              nixpkgs.config.allowUnfree = true;

              boot.kernelModules = [ "wl" ];

              boot.extraModulePackages =
                [ config.boot.kernelPackages.broadcom_sta ];

              # Disable the open-source broadcom modules
              boot.blacklistedKernelModules = [ "b43" "bcma" ];

              systemd.services.sshd.wantedBy =
                pkgs.lib.mkForce [ "multi-user.target" ];

              users.users.root.openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFfcOdH0DX1wM+1UvZ3nBeKuGLyXv+TcHxFyONUaxhhb josh@sparrowhawk"
              ];

              # Improve the build time
              isoImage.squashfsCompression = "gzip -Xcompression-level 1";
            })
          ];
        };
      };
    };
}

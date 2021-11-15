nixpkgs-unstable: { ... }:

{
  nixpkgs.overlays = [
    final: prev: {
      _1password-gui = final.callPackage nixpkgs-unstable._1password-gui {};
    }
  ];
}

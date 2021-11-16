nixpkgs-unstable: { pkgs, ... }:

let pkgsUnstable = import nixpkgs-unstable { config.allowUnfree = true; localSystem = "x86_64-linux"; };
in
{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      _1password-gui = pkgsUnstable._1password-gui;
    })
  ];

  environment.systemPackages = [
    pkgs._1password-gui
  ];
}

emacs-overlay: { pkgs, ... }:

{
  nixpkgs.overlays = [
    emacs-overlay.overlay
  ];

  home-manager.users.josh = {};
}

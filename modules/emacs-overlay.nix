emacs-overlay: { ... }:

{
  nixpkgs.overlays = [
    emacs-overlay.overlay
  ];
}

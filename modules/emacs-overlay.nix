{ inputs, ... }:

{
  nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
}

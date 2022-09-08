{
  description = "Pinned emacs-overlay packages";

  inputs = {
    nixpkgs.url =
      # "github:nixos/nixpkgs/nixos-unstable"
      "github:nixos/nixpkgs?rev=d6df226c53d46821bd4773bd7ec3375f30238edb";

    emacs-overlay.url =
      "github:nix-community/emacs-overlay?rev=1d0bad6294cd4228070a60f936c6e74976d2b327";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { emacs-overlay, ... }: emacs-overlay;
}

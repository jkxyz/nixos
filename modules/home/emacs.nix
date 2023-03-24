{ pkgs, ... }:

let
  emacsPgtk = pkgs.emacs.emacs.override { withPgtk = true; };
  emacsWithPackages = (pkgs.emacs.emacsPackagesFor emacsPgtk).emacsWithPackages
    (epkgs: with epkgs; [ vterm ]);
in {
  home.packages = with pkgs; [
    ripgrep
    fd
    emacs-all-the-icons-fonts
    nixfmt
    editorconfig-core-c
    fira-code
    pandoc
    gcc
    binutils
    pamixer
  ];

  home.sessionPath = [ "$HOME/.emacs.d/bin" ];

  home.file.".doom.d".source = ./emacs/doom;

  programs.emacs = {
    enable = true;
    package = emacsWithPackages;
  };
}

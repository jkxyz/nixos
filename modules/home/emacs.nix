{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fd
    emacs-all-the-icons-fonts
    nixfmt
    editorconfig-core-c
    fira-code

    ((emacsPackagesNgGen emacsPgtkGcc).emacsWithPackages
      (epkgs: [ epkgs.vterm ]))

    pamixer
  ];

  home.sessionPath = [ "~/.emacs.d/bin" ];

  home.file.".doom.d".source = ./emacs/doom;
}

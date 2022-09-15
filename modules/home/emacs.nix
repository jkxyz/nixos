{ pkgs, ... }:

{
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

    ((emacsPackagesFor emacs).emacsWithPackages
      (epkgs: [ epkgs.vterm ]))

    pamixer
  ];

  home.sessionPath = [ "$HOME/.emacs.d/bin" ];

  home.file.".doom.d".source = ./emacs/doom;
}

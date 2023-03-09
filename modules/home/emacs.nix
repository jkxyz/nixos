{ pkgs, ... }:

let
  emacsPgtk = pkgs.unstable.emacs.override { withPgtk = true; };
  emacsWithPackages =
    (pkgs.unstable.emacsPackagesFor emacsPgtk).emacsWithPackages (epkgs:
      with epkgs; [
        vterm

        # FIXME These packages were required to get `doom sync` to run properly
        dash
        f
        pkg-info
      ]);
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

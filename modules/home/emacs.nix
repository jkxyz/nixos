{ pkgs, ... }:

let
  emacs = (pkgs.emacsPackagesFor pkgs.emacsPgtkNativeComp).emacsWithPackages
    (epkgs: [
      epkgs.vterm

      # FIXME These packages were required to get `doom sync` to run properly
      epkgs.dash
      epkgs.f
      epkgs.pkg-info
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

    (pkgs.writers.writeBashBin "emacsframe" ''
      exec emacsclient --create-frame
    '')
  ];

  home.sessionPath = [ "$HOME/.emacs.d/bin" ];

  home.file.".doom.d".source = ./emacs/doom;

  programs.emacs = {
    enable = true;
    package = emacs;
  };

  services.emacs = {
    enable = true;
    package = emacs;
    defaultEditor = true;
  };
}

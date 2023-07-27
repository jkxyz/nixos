{ pkgs, ... }:

let
  emacsPgtk = pkgs.unstable.emacs29-pgtk;
  emacsWithPackages =
    (pkgs.unstable.emacsPackagesFor emacsPgtk).emacsWithPackages
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

  services.emacs = {
    enable = true;
    package = emacsWithPackages;
    client.enable = true;
    defaultEditor = true;
    startWithUserSession = "graphical";
  };
}

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    ripgrep
    fd
    emacs-all-the-icons-fonts
    nixfmt
    editorconfig-core-c
  ];

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [ epkgs.vterm ];
  };

  home.file.".doom.d".source = ./emacs/doom;
}

{ pkgs, ... }:

{
  home.packages = [ pkgs.emacsGcc ];

  home.file.".doom.d".source = ./emacs/doom;
}

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fd
    emacs-all-the-icons-fonts
    nixfmt
    editorconfig-core-c
  ];

  home.sessionPath = [ "~/.emacs.d/bin" ];

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [ epkgs.vterm ];
  };

  services.syncthing.enable = true;

  home.file.".doom.d".source = ./emacs/doom;
}

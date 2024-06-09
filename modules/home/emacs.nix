{ pkgs, lib, ... }:

let
  emacsWithPackages =
    (pkgs.emacsPackagesFor pkgs.unstable.emacs29-pgtk).emacsWithPackages
    (epkgs: [ epkgs.vterm ]);
in {
  home.packages = with pkgs; [
    ripgrep
    fd
    nixfmt-rfc-style
    editorconfig-core-c
    fira-code
    pandoc
    gcc
    binutils
    pamixer
    cmake
    gnumake
    nodePackages.prettier
    tailwindcss-language-server
    rustywind

    # Python
    python3
    poetry
    black
    isort
    nodePackages.pyright
    python311Packages.pyflakes
  ];

  home.sessionPath = [ "$HOME/.config/emacs/bin" ];

  xdg.configFile."doom".source = ./emacs/doom;

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

  systemd.user.services.emacs.Service.Restart = lib.mkForce "always";
}

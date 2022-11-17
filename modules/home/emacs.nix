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
      if [ "$(systemctl --user show emacs.service --property=ActiveState)" != "ActiveState=active" ]; then
        (
          until [ "$(systemctl --user show emacs.service --property=ActiveState)" == "ActiveState=active" ]; do
            echo 50
            sleep 1
          done
          echo 100
        ) |
        ${pkgs.gnome.zenity}/bin/zenity --progress \
          --title="Opening Emacs frame" \
          --text="Waiting for Emacs daemon..." \
          --percentage=0 \
          --auto-close

        if [ "$?" = 1 ]; then
          exit 1
        fi
      fi

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

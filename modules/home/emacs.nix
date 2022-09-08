{ pkgs, ... }:

let
  emacs = (pkgs.emacsPackagesFor pkgs.emacsPgtkNativeComp).emacsWithPackages
    (epkgs: [ epkgs.vterm ]);

  emacsframe = pkgs.writers.writeBashBin "emacsframe" ''
    exec ${emacs}/bin/emacsclient --create-frame
  '';

in {
  home.packages = with pkgs; [
    emacs
    emacsframe
    ripgrep
    fd
    emacs-all-the-icons-fonts
    nixfmt
    editorconfig-core-c
    fira-code
    pandoc
    gcc
    mu
    isync
    pamixer
  ];

  services.emacs = {
    enable = true;
    package = emacs;
    defaultEditor = true;
  };

  home.sessionPath = [ "$HOME/.emacs.d/bin" ];

  home.file.".doom.d".source = ./emacs/doom;

  accounts.email.accounts = {
    "josh@joshkingsley.me" = {
      address = "josh@joshkingsley.me";
      userName = "josh@joshkingsley.me";
      flavor = "fastmail.com";
      passwordCommand = "cat $HOME/.fastmailpassword";
      primary = true;
      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };
      realName = "Josh Kingsley";
      msmtp.enable = true;
    };
  };

  programs.msmtp.enable = true;
  programs.mbsync.enable = true;

  services.mbsync = {
    enable = true;
    preExec = "${pkgs.isync}/bin/mbsync -Ha";
    postExec = "${pkgs.mu}/bin/mu index -m $HOME/Maildir";
  };
}

{ lib, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home-manager.users.josh = { pkgs, ... }: {
    imports = [
      ./home/sway.nix
      ./home/emacs.nix
      ./home/development.nix
      ./home/clojure.nix
    ];

    home.stateVersion = "22.05";

    home.packages = with pkgs; [
      gnome.gnome-calculator
      gnome.nautilus
      unstable.grim
      unstable.slurp
      gnome.eog
      unstable.nextcloud-client
      unstable.htop
      unstable.keepassxc
      unstable.google-chrome
      unstable.thunderbird
      xdg-utils
      unstable.evince
      unstable.simple-scan
      unstable.calibre
      unstable.wl-color-picker
      unstable.scummvm
      unstable.vlc
      unstable.qownnotes
      dnsutils
      unstable.slack
      unstable.libreoffice-qt
      unstable.droidcam
      unstable.bitwig-studio
    ];

    xdg.enable = true;

    programs.bash = {
      enable = true;
      initExtra = ''
        source $HOME/.profile
      '';
    };

    programs.git = {
      enable = true;
      userName = "Josh Kingsley";
      userEmail = "josh@joshkingsley.me";
      ignores = [ ".direnv" ];
      difftastic.enable = true;
    };

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    # programs.direnv.nix-direnv.enableFlakes = true;

    # home.sessionVariables = { MOZ_ENABLE_WAYLAND = "1"; };

    # services.gammastep = {
    #   enable = true;
    #   latitude = 47.046501;
    #   longitude = 21.918944;
    # };

    # gtk = {
    #   enable = true;
    #   theme = {
    #     package = pkgs.gnome.gnome-themes-extra;
    #     # TODO Add a way to toggle light/dark
    #     name = "Adwaita";
    #   };
    # };

    # services.kdeconnect.enable = true;

    services.spotifyd = {
      enable = true;

      package = (pkgs.spotifyd.override {
        withKeyring = true;
        withMpris = true;
      });

      settings = {
        global = {
          username = "josh@joshkingsley.me";
          device_name = "sparrowhawk";
          use_keyring = true;
          use_mpris = true;
          device_type = "computer";
        };
      };
    };
  };
}

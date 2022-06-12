{ lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "slack"
      "1password"
      "spotify"
      "spotify-unwrapped"
    ];

  home-manager.users.josh = { pkgs, ... }:

    let
      chromium-wayland = pkgs.writers.writeBashBin "chromium-wayland" ''
        exec ${pkgs.unstable.ungoogled-chromium}/bin/chromium --enable-features=UseOzonePlatform --ozone-platform=wayland
      '';

    in {
      imports = [
        ./home/sway.nix
        ./home/emacs.nix
        ./home/development.nix
        ./home/clojure.nix
      ];

      home.packages = with pkgs; [
        unstable.slack
        _1password-gui
        unstable.spotify
        ungoogled-chromium
        chromium-wayland
        gnome.polari
        unstable.calibre
        unstable.mongodb-compass
        unstable.firefox
        unstable.thunderbird
        unstable.libreoffice
        unstable.evince
        gnome.gnome-calculator
        unstable.deluge
        gnome.nautilus
        filezilla
        unstable.grim
        unstable.slurp
        gnome.eog
        unstable.nextcloud-client
        unstable.dbeaver
        unstable.obs-studio
        unstable.obs-studio-plugins.wlrobs
        unstable.vlc
        unstable.htop
      ];

      services.nextcloud-client = {
        enable = true;
        package = pkgs.unstable.nextcloud-client;
      };

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
      };

      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;
      programs.direnv.nix-direnv.enableFlakes = true;

      home.sessionVariables = { MOZ_ENABLE_WAYLAND = "1"; };

      services.gammastep = {
        enable = true;
        latitude = 47.046501;
        longitude = 21.918944;
      };

      gtk = {
        enable = true;
        theme = { name = "Adwaita"; };
      };
    };
}

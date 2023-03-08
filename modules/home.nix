{ lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home-manager.users.josh = { pkgs, ... }:
    {
      imports = [
        ./home/sway.nix
        ./home/emacs.nix
        ./home/development.nix
        ./home/clojure.nix
      ];

      home.stateVersion = "22.05";

      home.packages = with pkgs; [
        unstable.slack
        gnome.gnome-calculator
        gnome.nautilus
        unstable.grim
        unstable.slurp
        gnome.eog
        unstable.nextcloud-client
        unstable.htop
        unstable.keepassxc
        unstable.firefox
        xdg-utils
      ];

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
      # programs.direnv.nix-direnv.enableFlakes = true;

      home.sessionVariables = { MOZ_ENABLE_WAYLAND = "1"; };

      services.gammastep = {
        enable = true;
        latitude = 47.046501;
        longitude = 21.918944;
      };

      gtk = {
        enable = true;
        theme = {
          package = pkgs.gnome.gnome-themes-extra;
          name = "Adwaita-dark";
        };
      };

      services.kdeconnect.enable = true;
    };
}

{ lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "slack"
      "1password"
      "spotify"
      "spotify-unwrapped"
    ];

  home-manager.users.josh = { pkgs, ... }: {
    imports = [
      ./home/sway.nix
      ./home/emacs.nix
      ./home/development.nix
      ./home/clojure.nix
      ./home/syncthing.nix
    ];

    home.packages = with pkgs; [
      slack
      _1password-gui
      spotify
      ungoogled-chromium
      gnome.polari
    ];

    programs.bash.enable = true;

    programs.git = {
      enable = true;
      userName = "Josh Kingsley";
      userEmail = "josh@joshkingsley.me";
      ignores = [ ".direnv" ];
    };

    programs.firefox.enable = true;

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };

    services.gammastep = {
      enable = true;
      latitude = 47.046501;
      longitude = 21.918944;
    };
  };
}

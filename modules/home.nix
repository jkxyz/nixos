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
      slack-wayland = pkgs.writers.writeBashBin "slack-wayland" ''
        ${pkgs.slack}/bin/slack --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland
      '';
      chromium-wayland = pkgs.writers.writeBashBin "chromium-wayland" ''
        ${pkgs.ungoogled-chromium}/bin/chromium --enable-features=UseOzonePlatform --ozone-platform=wayland
      '';

    in {
      imports = [
        ./home/sway.nix
        ./home/emacs.nix
        ./home/development.nix
        ./home/clojure.nix
        ./home/syncthing.nix
      ];

      home.packages = with pkgs; [
        slack
        slack-wayland
        _1password-gui
        spotify
        ungoogled-chromium
        chromium-wayland
        gnome.polari
        calibre
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
      programs.direnv.nix-direnv.enableFlakes = true;

      home.sessionVariables = { MOZ_ENABLE_WAYLAND = "1"; };

      services.gammastep = {
        enable = true;
        latitude = 47.046501;
        longitude = 21.918944;
      };
    };
}

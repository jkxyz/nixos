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
    ];

    programs.bash.enable = true;

    programs.git = {
      enable = true;
      userName = "Josh Kingsley";
      userEmail = "josh@joshkingsley.me";
    };

    programs.firefox.enable = true;
  };
}

{ ... }:

{
  home-manager.users.josh = { pkgs, ... }: {
    imports = [ ./home/emacs.nix ./home/development.nix ./home/syncthing.nix ];

    programs.bash.enable = true;

    programs.git = {
      enable = true;
      userName = "Josh Kingsley";
      userEmail = "josh@joshkingsley.me";
    };

    programs.firefox.enable = true;
  };
}

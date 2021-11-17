{ ... }:

{
  home-manager.users.josh = { pkgs, ... }: {
    imports = [ ./home/emacs.nix ];

    programs.bash = {
      enable = true;
      sessionVariables = { PATH = "~/.emacs.d/bin:$PATH"; };
    };

    programs.git = {
      enable = true;
      userName = "Josh Kingsley";
      userEmail = "josh@joshkingsley.me";
    };

    programs.firefox.enable = true;
  };
}

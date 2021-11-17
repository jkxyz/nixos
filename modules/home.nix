{ ... }:

{
  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  home-manager.users.josh = { pkgs, ... }: {
    imports = [ ./home/emacs.nix ];
    programs.firefox.enable = true;
  };
}

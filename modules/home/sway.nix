{ pkgs, ... }:

{
  xdg.configFile."sway/config".source = ./sway/config;
  xdg.configFile."sway/backgrounds".source = ./sway/backgrounds;
  xdg.configFile."mako/config".source = ./mako/config;
  xdg.configFile."kanshi/config".source = ./kanshi/config;
  xdg.configFile."networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = ${pkgs.wofi}/bin/wofi --dmenu
  '';
}

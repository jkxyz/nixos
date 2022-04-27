{ pkgs, ... }:

{
  # TODO Use systemd for sway services

  xdg.configFile."sway/config".source = ./sway/config;
  xdg.configFile."sway/backgrounds".source = ./sway/backgrounds;
  xdg.configFile."mako/config".source = ./mako/config;
  xdg.configFile."kanshi/config".source = ./kanshi/config;
  xdg.configFile."networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = ${pkgs.wofi}/bin/wofi --dmenu
  '';

  systemd.user.targets.sway-session = {
    Unit = {
      Description = "Sway compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };
}

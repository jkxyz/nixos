{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = [
    pkgs.fira-code
    pkgs.nodePackages_latest.typescript-language-server
  ];

  programs.helix = {
    enable = true;

    settings = {
      theme = "onedark";
    };

    languages = {
      language-server.tailwindcss-language-server = {
        command = "${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server";
        args = [ "--stdio" ];
      };

      language = [
        {
          name = "typescript";
          language-servers = [
            "typescript-language-server"
            "tailwindcss-language-server"
          ];
        }
      ];
    };
  };

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "Fira Code:size=8";
        dpi-aware = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };

  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    escapeTime = 0;
    mouse = true;
    terminal = "screen-256color";
  };
}

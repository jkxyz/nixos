{ config, lib, pkgs, ... }:

{
  xdg.configFile."sway/config".source = ./sway/config;
}

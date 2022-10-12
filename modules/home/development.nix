{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.nodejs
    unstable.postgresql
  ];
}

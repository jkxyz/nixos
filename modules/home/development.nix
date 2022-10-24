{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.nodejs
    unstable.postgresql
    unstable.rustc
    unstable.cargo
    unstable.rust-analyzer
  ];
}

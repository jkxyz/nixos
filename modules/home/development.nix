{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.nodejs
    unstable.postgresql
    unstable.rustc
    unstable.rustfmt
    unstable.cargo
    unstable.rust-analyzer
    unstable.jdk
    unstable.clojure
  ];
}

{ config, lib, pkgs, ... }:

{
  xdg.configFile."clojure/deps.edn".source = ./clojure/deps.edn;

  home.packages = [
    pkgs.unstable.clojure
    pkgs.unstable.clojure-lsp
    pkgs.unstable.clj-kondo
  ];
}

{ pkgs, ... }:

{
  home.packages = with pkgs; [ jdk clojure clojure-lsp babashka nodejs ];
}

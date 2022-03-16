{ pkgs, ... }:

{
  home.packages = with pkgs; [ unstable.clojure-lsp ];
}

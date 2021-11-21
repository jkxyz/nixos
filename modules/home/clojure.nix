{ config, lib, pkgs, ... }:

{
  home.file.".clojure/deps.edn".source = ./clojure/deps.edn;
}

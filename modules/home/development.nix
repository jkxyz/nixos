{ pkgs, ... }:

let

  clojure-lsp-static = pkgs.stdenv.mkDerivation rec {
    version = "2021.12.20-00.36.56";
    name = "clojure-lsp";

    src = pkgs.fetchurl {
      url =
        "https://github.com/clojure-lsp/clojure-lsp/releases/download/${version}/clojure-lsp-native-static-linux-amd64.zip";
      sha256 = "sha256-ZEOY0LW21nidAUm+K8ycDbdMDDIIGnffAszbOVm0r8E=";
    };

    buildInputs = [ pkgs.unzip ];

    unpackCmd = "unzip clojure-lsp-native-static-linux-amd64.zip";

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/bin
      cp clojure-lsp $out/bin
    '';
  };

in {
  home.packages = with pkgs; [ jdk clojure clojure-lsp-static babashka nodejs ];
}

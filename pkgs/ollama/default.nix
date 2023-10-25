{ stdenv, fetchurl, autoPatchelfHook }:

let
  version = "0.1.5";
  binary = fetchurl {
    url =
      "https://github.com/jmorganca/ollama/releases/download/v${version}/ollama-linux-amd64";
    hash = "sha256-ZBUL1ZQNx14Kzjqr0eeuBAw0OJ7D5V/FESfcmHiPrz0=";
  };
in stdenv.mkDerivation rec {
  pname = "ollama";
  inherit version;

  dontUnpack = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    install -Dm 755 ${binary} $out/bin/ollama
  '';
}

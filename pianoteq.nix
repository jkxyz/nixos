{ stdenv, lib, alsa-lib, freetype, xorg, libjack2, lv2, requireFile
, autoPatchelfHook, p7zip, makeWrapper, makeDesktopItem, copyDesktopItems }:

stdenv.mkDerivation rec {
  pname = "pianoteq";
  version = "v811";

  # nix hash file pianoteq/pianoteq_linux_v811.7z
  # nix-store --add-fixed sha256 pianoteq/pianoteq_linux_v811.7z
  src = requireFile {
    name = "pianoteq_linux_${version}.7z";
    sha256 = "sha256-vWvo+ctJ0yN6XeJZZVhA3Ul9eWJWAh7Qo54w0TpOiVw=";
    message = "Download pianoteq zip file.";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "pianoteq8";
      desktopName = "Pianoteq 8";
      exec = "pianoteq8";
    })
  ];

  nativeBuildInputs = [ p7zip makeWrapper copyDesktopItems ];

  sourceRoot = ".";

  unpackCmd = "7z x ${src}";

  libPath = lib.makeLibraryPath [
    freetype
    alsa-lib
    stdenv.cc.cc.lib
    xorg.libX11
    xorg.libXext
    libjack2
    lv2
  ];

  installPhase = ''
    # ls -alh 'Pianoteq 8/x86-64bit/Pianoteq 8.lv2'
    # exit 1

    install -Dm 755 'Pianoteq 8/x86-64bit/Pianoteq 8' $out/bin/pianoteq8
    install -Dm 755 'Pianoteq 8/x86-64bit/Pianoteq 8.lv2/Pianoteq_8.so' "$out/lib/lv2/Pianoteq 8.lv2/Pianoteq_8.so"

    patchelf --set-interpreter "$(< $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $libPath "$out/bin/pianoteq8"

    for f in "x86-64bit/Pianoteq 8.lv2/*.ttl"; do
      install -D "$i" "$out/lib/lv2/Pianoteq 8.lv2/$f"
    done

    runHook postInstall
  '';

  fixupPhase = ''
    makeWrapper $out/bin/pianoteq8 $out/bin/pianoteq8_wrapped --prefix LD_LIBRARY_PATH : "$libPath"
  '';
}

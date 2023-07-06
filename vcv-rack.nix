{ stdenv, fetchurl, autoPatchelfHook, unzip, xorg, alsa-lib, libjack2
, libpulseaudio, libGL, copyDesktopItems, makeDesktopItem, makeWrapper, gnome
, ... }:

stdenv.mkDerivation rec {
  name = "vcv-rack";
  version = "2.3.0";

  src = fetchurl {
    url = "https://vcvrack.com/downloads/RackFree-${version}-lin-x64.zip";
    sha256 = "sha256-8+NgRZ7SNOU61XXx05mqPVIcyhPhEChO6ES4l9Jfpb0=";
  };

  nativeBuildInputs = [ unzip autoPatchelfHook copyDesktopItems makeWrapper ];

  buildInputs = [ xorg.libX11 alsa-lib libjack2 libpulseaudio libGL ];

  desktopItems = [
    (makeDesktopItem {
      name = "vcv-rack";
      desktopName = "VCV Rack";
      exec = "Rack";
    })
  ];

  unpackCmd = "unzip ${src}";

  sourceRoot = "Rack2Free";

  installPhase = ''
    install -Dm 755 Rack $out/bin/Rack
    install -Dm 755 libRack.so $out/lib/libRack.so

    mkdir -p $out/share/vcv-rack
    cp -r res cacert.pem Core.json template.vcv Fundamental.vcvplugin $out/share/vcv-rack
  '';

  postFixup = ''
    wrapProgram $out/bin/Rack \
      --prefix PATH : ${gnome.zenity}/bin \
      --add-flags "--system $out/share/vcv-rack"
  '';
}

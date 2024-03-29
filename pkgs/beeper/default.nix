{ stdenv, writeShellScript, requireFile, makeDesktopItem, copyDesktopItems
, appimage-run, imagemagick }:

let
  version = "3.87.20-build-2311213pwlsuqeb";

  # nix hash file beeper-x.AppImage
  # nix-store --add-fixed sha256 beeper-x.AppImage
  beeperAppImage = requireFile {
    name = "beeper-${version}.AppImage";
    sha256 = "sha256-ZyeDqbOxQRiTymie/woaAQ5A868JuJCylPJL6WCSxI8=";
    message = "Download Beeper AppImage file: https://www.beeper.com/download";
  };
in stdenv.mkDerivation rec {
  pname = "beeper";
  inherit version;

  phases = [ "installPhase" ];

  desktopItems = [
    (makeDesktopItem {
      name = "beeper";
      desktopName = "Beeper";
      icon = "beeper";
      exec = "${appimage-run}/bin/appimage-run ${beeperAppImage}";
      categories = [ "Utility" ];
      comment = "Beeper: Unified Messenger";
      startupWMClass = "beeper";
    })
  ];

  nativeBuildInputs = [ copyDesktopItems appimage-run imagemagick ];

  installPhase = ''
    appimage-run -x beeper ${beeperAppImage}
    magick beeper/resources/icons/icon.png -resize 256x256 beeper.png
    install -Dm644 beeper.png $out/share/icons/hicolor/256x256/apps/beeper.png
    runHook postInstall
  '';
}

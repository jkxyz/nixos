{ stdenv, writeShellScript, requireFile, makeDesktopItem, copyDesktopItems
, appimage-run, imagemagick }:

let
  version = "3.70.17";

  # nix hash file beeper-x.AppImage
  # nix-store --add-fixed sha256 beeper-x.AppImage
  beeperAppImage = requireFile {
    name = "beeper-${version}.AppImage";
    sha256 = "sha256-Gx7Z99+FDV8x+GJnTbVnHCPmg5YdAAkf9lXyE0lHKLc=";
    message = "Download Beeper AppImage file: https://www.beeper.com/download";
  };

  launcherScript = writeShellScript "beeper-launcher" ''
    ${appimage-run}/bin/appimage-run ${beeperAppImage}
  '';
in stdenv.mkDerivation rec {
  pname = "beeper";
  inherit version;

  phases = [ "installPhase" ];

  desktopItems = [
    (makeDesktopItem {
      name = "beeper";
      desktopName = "Beeper";
      icon = "beeper";
      exec = "beeper-launcher";
      categories = [ "Utility" ];
      comment = "Beeper: Unified Messenger";
      startupWMClass = "beeper";
    })
  ];

  nativeBuildInputs = [ copyDesktopItems imagemagick ];

  installPhase = ''
    install -Dm 755 ${launcherScript} $out/bin/beeper-launcher
    magick ${./icon.png} -resize 256x256 beeper.png
    install -Dm644 beeper.png $out/share/icons/hicolor/256x256/apps/beeper.png
    runHook postInstall
  '';
}

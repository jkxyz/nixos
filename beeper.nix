{ stdenv, writeShellScript, requireFile, makeDesktopItem, copyDesktopItems
, appimage-run }:

let
  version = "3.63.16";

  # nix hash file beeper-x.AppImage
  # nix-store --add-fixed sha256 beeper-x.AppImage
  beeperAppImage = requireFile {
    name = "beeper-${version}.AppImage";
    sha256 = "sha256-fLHzLhcMXMiLQMkxRr+B4qK5i5MOzgz7LJLRb5RtoFA=";
    message = "Download Beeper AppImage file.";
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
      exec = "beeper-launcher";
    })
  ];

  nativeBuildInputs = [ copyDesktopItems ];

  installPhase = ''
    install -Dm 755 ${launcherScript} $out/bin/beeper-launcher
    runHook postInstall
  '';
}

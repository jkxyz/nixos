{ pkgs, config, ... }:

let
  package = pkgs.stdenv.mkDerivation rec {
    pname = "rss-bridge";
    version = "2022-06-14";

    src = pkgs.fetchFromGitHub {
      owner = "RSS-Bridge";
      repo = "rss-bridge";
      rev = version;
      sha256 = "sha256-yH+m65CIZokZSbnv1zfpKC/Qr/mPPC6dG49Zn62X0l4=";
    };

    postPatch = ''
      substituteInPlace lib/rssbridge.php \
        --replace "define('PATH_CACHE', PATH_ROOT . 'cache/');" "define('PATH_CACHE', getenv('JK_RSSBRIDGE_CACHE'));" \
    '';

    installPhase = ''
      mkdir $out/
      cp -R ./* $out
    '';
  };

  router = pkgs.writeText "rss-bridge-router.php" ''
    <?php

    if (preg_match('/\.(?:css|js|png)$/', $_SERVER["REQUEST_URI"])) {
      return false;    // serve the requested resource as-is.
    } else {
      include "${package}/index.php";
    }
  '';

  cacheDir = "${config.xdg.cacheHome}/rss-bridge";

  port = 42001;

in {
  # TODO Move this to a system service with a dedicated user
  systemd.user.services.rss-bridge = {
    Unit = {
      Description = "RSS Bridge";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      Environment = "JK_RSSBRIDGE_CACHE=${cacheDir}";
      ExecStartPre = "mkdir -p ${cacheDir}";
      ExecStart =
        "${pkgs.php}/bin/php -S localhost:${toString port} -t ${package} ${router}";
      Restart = "always";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}

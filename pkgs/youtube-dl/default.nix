{ lib, fetchgit, fetchpatch, buildPythonPackage, zip, ffmpeg, rtmpdump
, atomicparsley, pycryptodome, pandoc
# Pandoc is required to build the package's man page. Release tarballs contain a
# formatted man page already, though, it will still be installed. We keep the
# manpage argument in place in case someone wants to use this derivation to
# build a Git version of the tool that doesn't have the formatted man page
# included.
, generateManPage ? false, ffmpegSupport ? true, rtmpSupport ? true
, hlsEncryptedSupport ? true, installShellFiles, makeWrapper }:

buildPythonPackage rec {

  pname = "youtube-dl";
  version = "latest";

  src = fetchgit {
    url = "https://github.com/ytdl-org/youtube-dl";
    ref = "master";
    rev = "be008e657d79832642e2158557c899249c9e31cd";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];
  buildInputs = [ zip ] ++ lib.optional generateManPage pandoc;
  propagatedBuildInputs = lib.optional hlsEncryptedSupport pycryptodome;

  # Ensure these utilities are available in $PATH:
  # - ffmpeg: post-processing & transcoding support
  # - rtmpdump: download files over RTMP
  # - atomicparsley: embedding thumbnails
  makeWrapperArgs = let
    packagesToBinPath = [ atomicparsley ] ++ lib.optional ffmpegSupport ffmpeg
      ++ lib.optional rtmpSupport rtmpdump;
  in [ ''--prefix PATH : "${lib.makeBinPath packagesToBinPath}"'' ];

  setupPyBuildFlags = [ "build_lazy_extractors" ];

  postInstall = ''
    installShellCompletion youtube-dl.zsh
  '';

  # Requires network
  doCheck = false;
}

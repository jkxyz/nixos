{ pkgs, ... }: {
  nix.package = pkgs.unstable.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes

    keep-outputs = true
    keep-derivations = true
  '';
}

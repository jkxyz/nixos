{ pkgs, ... }: {
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes

    keep-outputs = true
    keep-derivations = true
  '';
}

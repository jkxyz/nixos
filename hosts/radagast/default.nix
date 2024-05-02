{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.apple-macbook-pro-14-1
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "josh" ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = [ "wl" ];

  boot.kernelParams = [ "consoleblank=60" ];

  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  networking.hostName = "radagast";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Bucharest";

  users.groups.storage = { };

  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "storage" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFfcOdH0DX1wM+1UvZ3nBeKuGLyXv+TcHxFyONUaxhhb josh@sparrowhawk"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExw1zRYbC1F9GdhzIg6D3X/taUeIWWHjJOXUryFqhii"
    ];
  };

  services.openssh.enable = true;

  environment.systemPackages = [
    pkgs.vim
    pkgs.git
    pkgs.cryptsetup
    pkgs.btrfs-progs

    # TODO Use a systemd target to prevent starting Plex until storage is mounted
    # https://daenney.github.io/2021/01/11/systemd-encrypted-filesystems/
    (pkgs.writers.writeBashBin "unlock-storage" ''
      set -e

      cryptsetup open /dev/disk/by-uuid/fab62996-2885-42b8-9510-9d46244fba46 crypt-storage-a
      cryptsetup open /dev/disk/by-uuid/1384f278-d2e5-426c-85d4-b650c079bfda crypt-storage-b
      mkdir -p /mnt/storage
      mount /dev/mapper/crypt-storage-a /mnt/storage
    '')

    (pkgs.writers.writeBashBin "lock-storage" ''
      umount /mnt/storage
      cryptsetup close crypt-storage-a
      cryptsetup close crypt-storage-b
    '')
  ];

  services.logind.lidSwitch = "ignore";

  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };

  services.deluge = {
    enable = true;

    web = {
      enable = true;
      openFirewall = true;
    };
  };

  users.users.deluge.extraGroups = [ "storage" ];

  services.plex = {
    enable = true;
    package = pkgs.unstable.plex;
    openFirewall = true;
  };

  users.users.plex.extraGroups = [ "storage" ];

  age.secrets.radagast-acme-env.file =
    "${inputs.self}/secrets/radagast-acme-env.age";

  services.prosody = {
    enable = true;

    admins = [ "josh@radagast.joshkingsley.me" ];

    ssl.cert = "/var/lib/acme/radagast.joshkingsley.me/fullchain.pem";
    ssl.key = "/var/lib/acme/radagast.joshkingsley.me/key.pem";

    virtualHosts."radagast.joshkingsley.me" = {
      enabled = true;
      domain = "radagast.joshkingsley.me";
      ssl.cert = "/var/lib/acme/radagast.joshkingsley.me/fullchain.pem";
      ssl.key = "/var/lib/acme/radagast.joshkingsley.me/key.pem";
    };

    muc = [{ domain = "conference.radagast.joshkingsley.me"; }];

    uploadHttp = { domain = "upload.radagast.joshkingsley.me"; };
  };

  security.acme = {
    defaults.email = "josh@joshkingsley.me";
    acceptTerms = true;

    certs = {
      "radagast.joshkingsley.me" = {
        group = "prosody";
        dnsProvider = "namecheap";
        environmentFile = config.age.secrets.radagast-acme-env.path;

        # Disable checking for DNS propagation, because it doesn't seem to work
        extraLegoFlags = [ "--dns.disable-cp" ];

        extraDomainNames = [
          "conference.radagast.joshkingsley.me"
          "upload.radagast.joshkingsley.me"
        ];
      };
    };
  };

  age.secrets.radagast-fren-env.file = "${inputs.self}/secrets/radagast-fren-env.age";

  users.users.fren = {
    isNormalUser = true;
    home = "/var/lib/fren";
    group = "fren";
  };

  users.groups.fren = {};

  systemd.services.fren = {
    description = "Fren";
    after = [ "prosody.service" ];
    wants = [ "prosody.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "fren";
      Group = "fren";
      CacheDirectory = "fren";
      StateDirectory = "fren";
      ExecStart = "${inputs.fren.packages.x86_64-linux.fren}/bin/fren";
      EnvironmentFile = config.age.secrets.radagast-fren-env.path;

      MemoryDenyWriteExecute = true;
      PrivateDevices = true;
      PrivateMounts = true;
      PrivateTmp = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

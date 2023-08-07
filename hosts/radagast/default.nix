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

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

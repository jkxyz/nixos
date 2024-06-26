{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  writeBabashka = pkgs.writers.makeScriptWriter { interpreter = "${pkgs.babashka}/bin/bb"; };
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
    ./hardware-configuration.nix
  ];

  jkxyz.home.users.josh.enable = true;
  jkxyz.nix.persistDerivations = true;

  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://devenv.cachix.org"
  ];

  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.bootspec.enable = true;

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.initrd.systemd.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sparrowhawk";

  # time.timeZone = "Europe/Bucharest";
  # time.timeZone = "Europe/Copenhagen";
  # time.timeZone = "Europe/London";
  # time.timeZone = "America/Los_Angeles";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  # networking.wireless.enable = true;

  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.supportedLocales = [ "all" ];

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable GDM and GNOME
  # services.xserver.displayManager.gdm.enable = true;

  # services.xserver.desktopManager.gnome = {
  #   enable = true;

  #   extraGSettingsOverrides = ''
  #     [org.gnome.desktop.input-sources]
  #     xkb-options=['ctrl:nocaps']

  #     [org.gnome.mutter]
  #     experimental-features=['scale-monitor-framebuffer']
  #   '';

  #   extraGSettingsOverridePackages =
  #     [ pkgs.gnome.mutter pkgs.gsettings-desktop-schemas ];
  # };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  sound.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.josh = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "scanner"
      "lp"
      "vboxusers"
      "audio"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    pavucontrol
    unzip
    zip
    qpwgraph
    appimage-run
    pciutils
  ];

  hardware.bluetooth.enable = true;

  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;

  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };

  networking.firewall.checkReversePath = "loose";

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  programs.kdeconnect.enable = true;

  services.flatpak.enable = true;

  programs.ssh = {
    startAgent = true;
    agentTimeout = "1h";
  };

  services.fwupd.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  virtualisation.virtualbox.host.enable = true;

  programs.nix-index.enable = true;
  programs.nix-index.enableBashIntegration = true;
  programs.command-not-found.enable = false;

  services.pcscd = {
    enable = true;
    plugins = [ pkgs.pcsc-safenet ];
  };

  programs.firefox = {
    enable = true;
    policies = {
      SecurityDevices = {
        Add = {
          "SafeNet" = "${pkgs.pcsc-safenet}/lib/libeToken.so";
        };
      };
    };
  };

  # Required for SafeNet
  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ];

  musnix.enable = true;

  # TODO Enable tlp

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

{ config, pkgs, lib, ... }:

let
  writeBabashka =
    pkgs.writers.makeScriptWriter { interpreter = "${pkgs.babashka}/bin/bb"; };

in {
  nix.binaryCaches = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
  ];

  nix.binaryCachePublicKeys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sparrowhawk";

  time.timeZone = "Europe/Bucharest";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  # networking.wireless.enable = true;

  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable GDM and GNOME
  services.xserver.displayManager.gdm.enable = true;

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

  services.pipewire.enable = true;
  xdg.portal.wlr.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";

  services.upower.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      alacritty
      wofi
      mako
      swaylock
      swayidle
      wl-clipboard
      brightnessctl
      wob
      pamixer
      acpi
      sysstat
      swaybg
      jc
      networkmanager_dmenu
      (writeBabashka "/bin/jk-sway-status" ./jk_sway_status.clj)
      swaywsr
      kanshi
    ];
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;

  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  environment.systemPackages = with pkgs; [ git vim pavucontrol unzip ];

  hardware.bluetooth.enable = true;

  hardware.bluetooth.settings = {
    General = { Enable = "Source,Sink,Media,Socket"; };
  };

  services.blueman.enable = true;

  virtualisation.docker.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

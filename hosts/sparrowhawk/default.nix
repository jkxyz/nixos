{ config, pkgs, lib, inputs, ... }:

let
  writeBabashka =
    pkgs.writers.makeScriptWriter { interpreter = "${pkgs.babashka}/bin/bb"; };

in {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
    ./hardware-configuration.nix
  ];

  jkxyz.home.users.josh.enable = true;
  jkxyz.nix.persistDerivations = true;

  nix.settings.substituters =
    [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];

  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
  time.timeZone = "Europe/Copenhagen";
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
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # };

  # Gnome VirtualFS - Needed for nautilus to work properly
  services.gvfs.enable = true;

  programs.dconf.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";

  services.upower.enable = true;

  programs.sway = {
    enable = false;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      alacritty
      rofi-wayland
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
      (writeBabashka "/bin/jk-sway-status" ./jk_sway_status.clj)
      swaywsr
      kanshi
      gnome.adwaita-icon-theme
      unstable.waybar
      unstable.font-awesome
      tpm2-tss
    ];

    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  services.greetd = let
    greetdStyle = pkgs.writeText "greetd.css" ''
      window {
        background-image: url("file://${
          ../../home/sway/backgrounds/Galaxy.jpg
        }");
        background-size: cover;
        background-position: center;
      }

      box#body {
        background-color: rgba(50, 50, 50, 0.5);
        border-radius: 10px;
        padding: 50px;
        color: #fafafa;
      }

      #clock {
        color: rgba(250, 250, 250, 0.8);
      }
    '';
    swayConfig = pkgs.writeText "greetd-sway-config" ''
      # Fix from here: https://github.com/swaywm/sway/wiki#gtk-applications-take-20-seconds-to-start
      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK

      exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet --layer-shell --command sway --style ${greetdStyle}; swaymsg exit"
    '';
  in {
    enable = false;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
      };
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = false;
  # hardware.pulseaudio = {
  #   enable = true;
  #   # extraModules = [ pkgs.pulseaudio-modules-bt ];
  #   package = pkgs.pulseaudioFull;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;

  users.users.josh = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "networkmanager" "docker" "scanner" "lp" "vboxusers" ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    pavucontrol
    unzip
    zip
    qpwgraph
    appimage-run
  ];

  hardware.bluetooth.enable = true;

  hardware.bluetooth.settings = {
    General = { Enable = "Source,Sink,Media,Socket"; };
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;

  services.gnome.gnome-keyring.enable = true;

  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };

  networking.firewall.checkReversePath = "loose";

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  programs.kdeconnect.enable = true;

  programs._1password = {
    enable = true;
    package = pkgs.unstable._1password;
  };

  programs._1password-gui = {
    enable = true;
    package = pkgs.unstable._1password-gui;
    polkitPolicyOwners = [ "josh" ];
  };

  programs.thunar.enable = true;

  services.flatpak.enable = true;

  programs.ssh.startAgent = true;

  services.fwupd.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  virtualisation.virtualbox.host = {
    enable = true;
    package = pkgs.unstable.virtualbox;
  };

  programs.nix-index.enable = true;
  programs.nix-index.enableBashIntegration = true;
  programs.command-not-found.enable = false;

  # TODO Enable tlp

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

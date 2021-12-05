{ config, pkgs, lib, ... }:

{
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

  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable GDM and GNOME
  services.xserver.displayManager.gdm.enable = true;

  services.xserver.desktopManager.gnome = {
    enable = true;

    extraGSettingsOverrides = ''
      [org.gnome.desktop.input-sources]
      xkb-options=['ctrl:nocaps']

      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer']
    '';

    extraGSettingsOverridePackages =
      [ pkgs.gnome.mutter pkgs.gsettings-desktop-schemas ];
  };

  services.pipewire.enable = true;
  xdg.portal.wlr.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";

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

      (pkgs.writers.writeBashBin "jk-sway-status" ''
        system_out=$(mktemp)

        # vmstat takes 1 second to sample CPU usage, so run it in the background
        while true; do
          echo $(vmstat --unit M 1 2 | tail -1 | awk '{ print "CPU: " (100-$15) "% | Mem: " $4 " free" }') > $system_out
        done &

        while true; do
          date=$(date +'%a %d %b %H:%M')
          battery=$(acpi --battery)
          disk=$(df | awk '{ if ($6 == "/") { print "Disk: " $5 } }')
          system=$(cat $system_out)

          if [ -n "$system" ]; then
            echo -n "$system | "
          fi

          echo "$disk | $battery | $date"

          sleep 1
        done
      '')
    ];
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;

  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  environment.systemPackages = with pkgs; [ git vim pavucontrol ];

  hardware.bluetooth.enable = true;

  hardware.bluetooth.settings = {
    General = { Enable = "Source,Sink,Media,Socket"; };
  };

  services.blueman.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

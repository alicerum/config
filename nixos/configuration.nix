# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    maxJobs = pkgs.lib.mkOverride 0 3;
    binaryCaches = pkgs.lib.mkOverride 0
    [
      "http://cache.nixos.org"
      "https://hydra.nixos.org"
    ];

    extraOptions =
    "
      gc-keep-outputs = true
      gc-keep-derivations = true
    ";
  };

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "wyvernscave"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless.

  networking.extraHosts = ''
    10.9.130.99 qw-app-t00.qiwi.com
  '';

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # List packages installed in system profile. To search by name, run:
  # -env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    chromium
    gitFull
    pulseaudio
    sudo
    bumblebee
    gl117

    oraclejdk7
    idea.idea-community

    dmenu
    wmname
    /* gnome3.gdm */
    terminator
    pmutils

    skype
  ];

  nixpkgs.config.chromium.enablePepperFlash = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us,ru";
  services.xserver.xkbOptions = "grp:caps_toggle,grp_led:scroll";

  # Enable the KDE Desktop Environment.
  # services.xserver.desktopManager.kde4.enable = true;
  # services.xserver.displayManager.kdm.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.synaptics.enable = true;
  services.xserver.videoDrivers = [ "intel" "nvidia" ];

  nixpkgs.config.dwm.patches = [ /home/wv/dwm-config/config.patch ];

  hardware.bumblebee.enable = true;

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Moscow";

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      bakoma_ttf cm_unicode
      corefonts
      freefont_ttf
      inconsolata junicode
      libertine
      liberation_ttf
      ubuntu_font_family
      /* unifont */ vistafonts wqy_microhei wqy_zenhei
      terminus_font
    ];
  };

  users.extraGroups = {
    bumblebee = { };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.wv = {
    name = "wv";
    hashedPassword = "$6$Pcher5jb$Sy1tmiAUV8pp6iPshWlj.cZgdkQEtNmqmh239QtCmhLJBANZurfGg3TZpZcnFJERtiZ6IDzjp.qLxNWNJiy6n.";
    createHome = true;
    home = "/home/wv";
    group = "users";
    extraGroups = [ "wheel" "bumblebee" "video" ];
    shell = "/run/current-system/sw/bin/bash";
  };

  environment.variables = {
    NIX_PATH = pkgs.lib.mkOverride 0 [
      "/opt/nixpkgs"
      "nixpkgs=/opt/nixpkgs"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
  };
}

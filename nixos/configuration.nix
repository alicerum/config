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

  nixpkgs.config.allowUnfree = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

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
    ];
  };

  # List packages installed in system profile. To search by name, run:
  # -env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    sudo
    gitFull
    vim
    maven
    pulseaudio
    haskellPlatform.ghc
    haskellPackages.xmobar
    haskellPackages.xmonad
    haskellPackages.xmonadContrib
    haskellPackages.xmonadExtras

    dmenu
    terminator
    chromium

    oraclejdk7
    pidgin

    thunderbird
    slock
  ];

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
  # services.xserver.displayManager.kdm.enable = true;
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.wv = {
    name = "wv";
    hashedPassword = "$6$Pcher5jb$Sy1tmiAUV8pp6iPshWlj.cZgdkQEtNmqmh239QtCmhLJBANZurfGg3TZpZcnFJERtiZ6IDzjp.qLxNWNJiy6n.";
    createHome = true;
    home = "/home/wv";
    group = "users";
    extraGroups = [ "wheel" ];
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

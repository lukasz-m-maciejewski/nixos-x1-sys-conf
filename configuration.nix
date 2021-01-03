# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "GraceHopper";
  networking.networkmanager.enable = true;

  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;
  networking.interfaces.wwp0s20u4.useDHCP = true;

  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  environment.pathsToLink = [ "/libexec" ];

  # services.xserver.enable = true;
  # services.xserver.layout = "pl";
  # services.xserver.dpi = 120;
  # services.xserver.xkbOptions = "ctrl:nocaps";
  # services.xserver.desktopManager.xterm.enable = false;
  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.displayManager.defaultSession = "none+i3";
  # services.xserver.windowManager.i3 = {
  #   enable = true;
  #   package = pkgs.i3-gaps;
  #   extraPackages = with pkgs; [ dmenu rofi i3status i3lock i3blocks ];
  #   extraSessionCommands = ''
  #     ${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources
  #   '';
  # };
  services.xserver = {
    enable = true;
    layout = "pl";
    dpi = 120;
    xkbOptions = "ctrl:nocaps";
    displayManager = {
      lightdm.enable = true;
      defaultSession = "xfce+i3";
    };
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ dmenu rofi i3status i3lock i3blocks ];
      extraSessionCommands = ''
        ${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources
      '';
    };
  };

  programs.dconf.enable = true;

  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome3.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
    accelSpeed = "0.5";
  };

  services.autorandr.enable = true;

  #xsession.pointerCursor = {
  #  name = "Vanilla-DMZ";
  #  package = pkgs.vanilla-dmz;
  #  size = 128;
  #};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lukaszm = {
    createHome = true;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "disk"
    ]; # Enable ‘sudo’ for the user.
    uid = 1000;
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    firefox
    emacs
    git
    htop
    networkmanagerapplet
    which
    tmux
    rxvt_unicode
    terminator
    xfce.thunar
    ripgrep
    fd
    shellcheck
    cmake
    gcc10
    gnumake
    ledger
    nixfmt
    sbcl
    jdk11
  ];

  fonts.fonts = with pkgs; [ nerdfonts source-code-pro terminus_font ];

  fonts.fontconfig = {
    dpi = 120;
    antialias = true;
    subpixel.lcdfilter = "light";
    hinting.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

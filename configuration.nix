{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  hardware.cpu.intel.updateMicrocode = true;

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
      # package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ dmenu rofi i3status i3lock i3blocks ];
      extraSessionCommands = ''
        ${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources
      '';
    };
  };

  environment.etc."X11/xorg.conf.d/99-no-touchscreen.conf" = {
    text = ''
      Section "InputClass"
          Identifier         "Touchscreen catchall"
          MatchIsTouchscreen "on"
          Option "Ignore" "on"
      EndSection
    '';
  };

  programs.dconf.enable = true;
  programs.nm-applet.enable = true;
  virtualisation.docker.enable = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser pkgs.brgenml1lpr ];
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
    accelSpeed = "0.5";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lukaszm = {
    createHome = true;
    isNormalUser = true;
    extraGroups =
      [ "wheel" "networkmanager" "video" "audio" "disk" "dialout" "docker" ];
    uid = 1000;
  };
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    lxappearance
    gitAndTools.gitFull
    htop
    which
    rxvt_unicode
    terminator
    cmake
    gcc10
    gnumake
    jdk11
    ntfs3g
    lshw
    usbutils
    pciutils
    dmidecode
    lm_sensors
    smartmontools

    iotop
    iftop
    wget
    curl
    tcpdump
    telnet
    whois

    file
    lsof
    xclip
    rsync
    tree

    xz
    lz4
    zip
    unzip

    inotify-tools
  ];

  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;

    fonts = with pkgs; [
      nerdfonts
      source-code-pro
      terminus_font
      fira-mono
      libertine
      open-sans
      twemoji-color-font
      liberation_ttf
    ];

    fontconfig = {
      dpi = 120;
      antialias = true;
      subpixel.lcdfilter = "light";
      hinting.enable = true;
      defaultFonts = {
        monospace = [ "Iosevka Term" ];
        serif = [ "Linux Libertine" ];
        sansSerif = [ "Open Sans" ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:
  services.openssh.enable = true;
  services.autorandr.enable = true;

  documentation.dev.enable = true;

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

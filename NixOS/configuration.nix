{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader and kernel settings
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Use latest kernel.
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "nvme_load=yes" ];

    # v4l2loopback module for OBS Virtual Camera
    extraModulePackages = with pkgs.linuxPackages_latest; [
      v4l2loopback
    ];
    kernelModules = [ "v4l2loopback" ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Virtual Camera" exclusive_caps=1
    '';
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "XeroNix"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true; # Enable polkit for device access (important for v4l2loopback)
  };

  # Enable CUPS to print documents.
  services = {
    printing.enable = true;
    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      # jack.enable = true;
      # media-session.enable = true;
    };
  };

  # Automount Drives
  fileSystems."/mnt/XeroLinux" = {
    device = "/dev/disk/by-uuid/c17ca2c4-b59b-467d-91fb-e69af504799f";
    fsType = "ext4";
  };

  fileSystems."/mnt/Stuffed" = {
    device = "/dev/disk/by-uuid/0b1f92a9-cb26-4f05-8346-4059285c5088";
    fsType = "xfs";
  };

  fileSystems."/mnt/Linux" = {
    device = "/dev/disk/by-uuid/d19923d1-2482-4d8b-9d44-f83a75440165";
    fsType = "ext4";
  };

  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-uuid/8a69f985-6d4d-499b-a462-decd15f00cd1";
    fsType = "xfs";
  };

  hardware = {
    # Graphics
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    # Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez;
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Beirut";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the KDE Plasma Desktop Environment.
  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };
      };
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    openssh.enable = true;
    desktopManager.plasma6.enable = true;
    flatpak.enable = true;
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "xero";

  # Add Flatpak remotes
  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  programs = {
    # OBS Studio with Virtual Camera enabled
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };

    # XWayland
    xwayland = {
      enable = true;
    };
    # Steam Ahead
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      gamescopeSession.enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin pkgs.mangohud];
    };
    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
    # Install zsh
    zsh = {
      enable = true;
      enableBashCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    zsh.ohMyZsh = {
      enable = true;
      plugins = ["git"];
      custom = "$HOME/.oh-my-zsh/custom/";
      theme = "powerlevel10k/powerlevel10k";
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xero = {
    isNormalUser = true;
    description = "xero";
    extraGroups = ["networkmanager" "wheel" "video"];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    eza
    mpv
    git
    gtk3
    meld
    wget
    curl
    btop
    inxi
    hugo
    uget
    mesa
    unrar
    p7zip
    cmake
    figlet
    lolcat
    yt-dlp
    amarok
    hblock
    rustup
    amdvlk
    pciutils
    wineasio
    hw-probe
    topgrade
    v4l-utils
    fastfetch
    hardinfo2
    winetricks
    oh-my-posh
    ffmpeg-full
    imagemagick
    gtk_engines
    linux-firmware
    vulkan-headers
    grml-zsh-config
    mesa-gl-headers
    bash-completion
    nerd-fonts.hack
    zsh-powerlevel10k
    gnome-disk-utility
    gtk-engine-murrine
    lomiri.cmake-extras
    nerd-fonts.meslo-lg
    nerd-fonts.fira-code
    driversi686Linux.mesa
    noto-fonts-color-emoji
    vulkan-utility-libraries
    kdePackages.kdeconnect-kde
    kdePackages.kde-gtk-config
    kdePackages.dolphin-plugins
    wineWowPackages.waylandFull
    kdePackages.qtstyleplugin-kvantum
    kdePackages.plasma-browser-integration
    (python3.withPackages (
      ps:
        with ps; [
          pipx
          mkdocs
          mkdocs-macros
          mkdocs-gitlab
          mkdocs-get-deps
          mkdocs-material
          mkdocs-autorefs
          mkdocs-rss-plugin
          mkdocs-glightbox
          mkdocs-redirects
          mkdocs-awesome-nav
          mkdocs-material-extensions
        ]
    ))
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
  system.stateVersion = "25.05"; # Did you read the comment?
}

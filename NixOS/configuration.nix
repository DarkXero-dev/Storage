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
    kernelParams = [
      "quiet"
      "splash"
      "nvme_load=yes"
    ];

    # Load and configure v4l2loopback for OBS Flatpak virtual camera
    extraModulePackages = with pkgs.linuxPackages_latest; [
      v4l2loopback
    ];
    kernelModules = [ "v4l2loopback" "kvm-intel" "kvm-amd" ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Virtual Camera" exclusive_caps=1
    '';
  };

  # Virt-Manager
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["xero"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  # Enable networking
  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    bridges = {
      "br0" = {
        interfaces = [ "enp17s0" ];
      };
    };
    interfaces.br0.useDHCP = true;
    interfaces.enp17s0.useDHCP = true;
    hostName = "XeroNix"; # Define your hostname.
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true; # Needed for device permission in Flatpak
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
      # jack.enable = true; # If JACK apps needed
      # media-session.enable = true; # session manager
    };

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

  # Enable Android Support
  programs.adb.enable = true;

  # Enable automatic login for the user "xero".
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "xero";

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

  # Add Flatpak remotes
  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  programs = {
    # OBS Studio is installed as Flatpak; do NOT enable native obs-studio virtual camera
    # Do NOT enable programs.obs-studio.enableVirtualCamera here to avoid conflicts

    # XWayland
    xwayland.enable = true;

    # Steam Ahead with extra options
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

    # Zsh config
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

  # Define user account "xero" with video group access for webcam permissions
  users.users.xero = {
    isNormalUser = true;
    description = "xero";
    extraGroups = [ "networkmanager" "wheel" "video" "adbusers" "libvirtd" ];
    packages = with pkgs; [
      kdePackages.kate
      # thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config = {
  allowUnfree = true;
  };

  # System packages
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
    iptables
    pciutils
    wineasio
    hw-probe
    topgrade
    qemu-user
    spice-gtk
    qemu-utils
    v4l-utils
    fastfetch
    hardinfo2
    winetricks
    oh-my-posh
    ffmpeg-full
    imagemagick
    gtk_engines
    bridge-utils
    spice-protocol
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
    kdePackages.yakuake
    nerd-fonts.meslo-lg
    nerd-fonts.fira-code
    driversi686Linux.mesa
    noto-fonts-color-emoji
    vulkan-utility-libraries
    kdePackages.kdeconnect-kde
    kdePackages.kde-gtk-config
    kdePackages.dolphin-plugins
    wineWowPackages.waylandFull
    obs-studio-plugins.obs-vkcapture
    kdePackages.qtstyleplugin-kvantum
    androidenv.androidPkgs.platform-tools
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

  # Commented out examples of services or programs you might enable later
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Firewall settings (disabled or customized as required)
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  # System state version
  system.stateVersion = "25.05"; # Did you read the comment?
}

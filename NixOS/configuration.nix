{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./mounts.nix
    ./pkgs.nix
    ./virtualization.nix
  ];

  # Bootloader and kernel settings
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

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
    kernelModules = [ "v4l2loopback" "kvm-amd" ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Virtual Camera" exclusive_caps=1
    '';
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    bridges."br0".interfaces = [ "enp17s0" ];
    interfaces = {
      br0.useDHCP = true;
      enp17s0.useDHCP = true;
    };
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
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      # jack.enable = true; # If JACK apps needed
      # media-session.enable = true; # session manager
    };

    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };

      autoLogin = {
        enable = true;
        user = "xero";
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
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        custom = "$HOME/.oh-my-zsh/custom/";
        theme = "powerlevel10k/powerlevel10k";
      };
    };
  };

  # Define user account "xero" with video group access for webcam permissions
  users.users.xero = {
    isNormalUser = true;
    description = "xero";
    extraGroups = [ "networkmanager" "wheel" "video" "adbusers" ];
    packages = with pkgs; [
      kdePackages.kate
      # thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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

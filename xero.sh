#!/usr/bin/env bash

set -eo pipefail
trap 'echo -e "${RED}❌ An error occurred on line $LINENO. Exiting.${RESET}"' ERR

# Colors
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

# Colors
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

# Banner Functions
print_title() {
  echo -e "${BOLD}${BLUE}"
  cat <<'EOF'
╔══════════════════════════════════════════════════════╗
║                🧩  XERO DE INSTALLER  🧩             ║
╚══════════════════════════════════════════════════════╝
EOF
  echo -e "${RESET}"
}

print_section() {
  local msg="$1"
  echo -e "\n${CYAN}"
  figlet -w 50 -f slant "$msg" 2>/dev/null || echo -e "=== $msg ==="
  echo -e "${RESET}"
}

# Pre-checks
check_vanilla_arch() {
  if ! grep -q '^ID=arch' /etc/os-release || ! [ -f /etc/arch-release ]; then
    echo
    echo -e "${RED}This script is for vanilla Arch Linux only. Exiting.${RESET}"
    exit 1
  fi
}

check_existing_de() {
  local known_de_packages=(
    plasma-desktop gnome-shell xfce4-session hyprland cosmic-session-git
    budgie-desktop cinnamon pantheon-session deepin kde-applications lxqt-session
    sway i3-wm openbox awesome enlightenment mate-session gdm sddm lightdm
  )

  for pkg in "${known_de_packages[@]}"; do
    if pacman -Q "$pkg" &>/dev/null; then
      echo -e "${RED}"
      figlet -f slant "DE Detected" 2>/dev/null || echo "DE Detected"
      echo -e "${RESET}"
      echo -e "${CYAN}${pkg}${RESET} is already installed !"
      echo
      echo -e "${YELLOW}This script is for fresh/clean installs only. Exiting.${RESET}"
      echo
      exit 1
    fi
  done
}

check_gpu_compatibility() {
  DE="$1"
  if [[ "$DE" == "hyprland" || "$DE" == "cosmic" ]]; then
    echo -e "${BLUE}Checking GPU compatibility for $DE...${RESET}"
    VIRT=$(systemd-detect-virt)
    if [[ "$VIRT" != "none" ]]; then
      echo -e "${YELLOW}Virtual machine detected: $VIRT${RESET}"
      echo -e "${CYAN}Please ensure 3D acceleration is enabled. Real hardware is recommended.${RESET}"
    else
      echo -e "${GREEN}Running on real hardware — good to go!${RESET}"
    fi
  fi
}

start_point() {
  if [[ -f /tmp/.xapi_done ]]; then
    echo -e "${YELLOW}🛈 AUR helper already installed. Skipping xapi.sh...${RESET}"
    return
  fi

  echo -e "${GREEN}Fetching XeroLinux Toolkit & AUR Helper...${RESET}"

  # Run in a subshell and monitor changes
  BEFORE=$(pacman -Qq | wc -l)

  bash -c 'curl -fsSL https://xerolinux.xyz/script/xapi.sh | bash'

  AFTER=$(pacman -Qq | wc -l)

  if [[ "$AFTER" -gt "$BEFORE" ]]; then
    echo -e "${YELLOW}🔁 System changed by xapi.sh. Restarting script for a clean state.${RESET}"
    touch /tmp/.xapi_done
    exec "$0" "$@"
  fi

  touch /tmp/.xapi_done
}

install_packages() {
  local spinner=('-' '\' '|' '/')
  local failed_packages=()
  local count=1
  local total=$#

  for pkg in "$@"; do
    echo -ne "${CYAN}[...] Installing ${pkg}...${RESET}"

    # Start spinner in background
    i=0
    (
      while :; do
        echo -ne "\r${CYAN}[${spinner[i]}] Installing ${pkg}...${RESET}"
        i=$(( (i + 1) % 4 ))
        sleep 0.1
      done
    ) &
    SPIN_PID=$!

    # Install the package
    if sudo pacman -S --noconfirm --needed "$pkg" &>/dev/null; then
      kill $SPIN_PID &>/dev/null
      wait $SPIN_PID 2>/dev/null || true
      echo -ne "\r\033[2K${GREEN}[✔] Installed ${pkg}${RESET}\n"
    else
      kill $SPIN_PID &>/dev/null
      wait $SPIN_PID 2>/dev/null || true
      echo -ne "\r\033[2K${RED}[✘] Failed ${pkg}${RESET}\n"
      failed_packages+=("$pkg")
    fi

    ((count++))
  done

  if (( ${#failed_packages[@]} > 0 )); then
    echo -e "\n${YELLOW}⚠ Some packages failed to install:${RESET}"
    for pkg in "${failed_packages[@]}"; do
      echo -e "${RED}- $pkg${RESET}"
    done
  fi
}


install_plasma() {
  print_section "KDE Plasma"
  start_point
  install_packages linux-headers nano kf6 power-profiles-daemon jq xmlstarlet unrar zip unzip 7zip \
  qt6-3d qt6-5compat qt6-base qt6-charts qt6-connectivity qt6-declarative qt6-graphs qt6-grpc \
  qt6-httpserver qt6-imageformats qt6-languageserver qt6-location qt6-lottie qt6-multimedia \
  qt6-networkauth qt6-positioning qt6-quick3d qt6-quick3dphysics qt6-quickeffectmaker \
  qt6-quicktimeline qt6-remoteobjects qt6-scxml qt6-sensors qt6-serialbus qt6-serialport \
  qt6-shadertools qt6-speech qt6-svg qt6-tools qt6-translations qt6-virtualkeyboard qt6-wayland \
  qt6-webchannel qt6-webengine qt6-websockets qt6-webview plasma-desktop packagekit-qt6 packagekit \
  dolphin kcron khelpcenter kio-admin ksystemlog breeze plasma-workspace plasma-workspace-wallpapers \
  powerdevil plasma-nm kaccounts-integration kdeplasma-addons plasma-pa plasma-integration \
  plasma-browser-integration plasma-wayland-protocols plasma-systemmonitor kpipewire keysmith \
  krecorder kweather plasmatube plasma-pass ocean-sound-theme qqc2-breeze-style plasma5-integration \
  kdeconnect kdenetwork-filesharing kget kio-extras kio-gdrive kio-zeroconf colord-kde gwenview kamera \
  kcolorchooser kdegraphics-thumbnailers kimagemapeditor kolourpaint okular spectacle svgpart ark kate \
  kcalc kcharselect kdebugsettings kdf kdialog keditbookmarks kfind kgpg konsole markdownpart yakuake \
  audiotube elisa ffmpegthumbs plasmatube dolphin-plugins pim-data-exporter pim-sieve-editor \
  emoji-font gcc-libs glibc icu kauth kbookmarks kcmutils kcodecs kcompletion kconfig kconfigwidgets \
  kcoreaddons kcrash kdbusaddons kdeclarative kglobalaccel kguiaddons ki18n kiconthemes kio kirigami \
  kirigami-addons kitemmodels kitemviews kjobwidgets kmenuedit knewstuff knotifications knotifyconfig \
  kpackage krunner kservice ksvg kwidgetsaddons kwindowsystem kxmlgui libcanberra libksysguard \
  libplasma libx11 libxcb libxcursor libxi libxkbcommon libxkbfile plasma-activities \
  plasma-activities-stats plasma5support polkit polkit-kde-agent qt6-5compat qt6-base qt6-declarative \
  qt6-wayland sdl2 solid sonnet systemsettings wayland xcb-util-keysyms xdg-user-dirs scim \
  extra-cmake-modules intltool wayland-protocols xf86-input-libinput sddm-kcm bluedevil breeze-gtk \
  drkonqi kde-gtk-config kdeplasma-addons kinfocenter kscreen ksshaskpass oxygen oxygen-sounds \
  xdg-desktop-portal-kde breeze-grub flatpak-kcm networkmanager-qt quota-tools qt5-x11extras gpsd \
  pacman-contrib cmake falkon
  echo
  sudo systemctl enable sddm.service power-profiles-daemon.service || echo -e "${YELLOW}Warning: sddm not found.${RESET}"
}

install_gnome() {
  print_section "GNOME"
  start_point
  install_packages linux-headers evince extension-manager epiphany gdm gnome-subtitles gnac gmtk \
  gnome-backgrounds gnome-calculator gnome-calendar gnome-characters gnome-clocks \
  gnome-color-manager gnome-connections gnome-terminal-transparency gnome-contacts \
  gnome-control-center gnome-disk-utility gnome-font-viewer gnome-gesture-improvements \
  gnome-keyring gnome-logs gnome-maps gnome-menus gnome-network-displays gnome-remote-desktop \
  gnome-session gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-system-monitor \
  gnome-text-editor gnome-themes-extra gnome-tweaks gnome-user-share gnome-weather grilo-plugins \
  gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive \
  gvfs-smb gvfs-wsdd loupe nautilus rygel power-profiles-daemon simple-scan snapshot sushi tecla \
  totem xdg-desktop-portal-gnome xdg-user-dirs-gtk nano jq xmlstarlet unrar zip unzip 7zip \
  libadwaita adwaita-fonts adwaita-cursors adwaita-icon-theme adwaita-icon-theme-legacy
  echo
  sudo systemctl enable gdm.service power-profiles-daemon.service || echo -e "${YELLOW}Warning: gdm not found.${RESET}"
}

install_xfce() {
  print_section "XFCE"
  start_point
  install_packages linux-headers evince extension-manager epiphany gdm gnome-subtitles gnac gmtk gnome-backgrounds gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-color-manager gnome-connections gnome-terminal-transparency gnome-contacts gnome-control-center gnome-disk-utility gnome-font-viewer gnome-gesture-improvements gnome-keyring gnome-logs gnome-maps gnome-menus gnome-network-displays gnome-remote-desktop gnome-session gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-system-monitor gnome-text-editor gnome-themes-extra gnome-tweaks gnome-user-share gnome-weather grilo-plugins gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd loupe nautilus rygel power-profiles-daemon simple-scan snapshot sushi tecla totem xdg-desktop-portal-gnome xdg-user-dirs-gtk nano jq xmlstarlet unrar zip unzip 7zip libadwaita adwaita-fonts adwaita-cursors adwaita-icon-theme adwaita-icon-theme-legacy power-profiles-daemon zip unzip 7zip
  echo
  sudo systemctl enable lightdm.service power-profiles-daemon.service 2>/dev/null || echo "Warning: lightdm.service not found."
}

install_hypr() {
  print_section "Hyprland"
  start_point
  install_packages hyprland hypridle hyprland-protocols hyprlock hyprpaper hyprpicker \
  hyprpolkitagent hyprsunset linux-headers pacman-contrib xdg-desktop-portal-hyprland \
  xdg-user-dirs power-profiles-daemon nwg-displays sddm
  xdg-user-dirs-update
  echo
  sudo systemctl enable power-profiles-daemon.service sddm.service
  echo
  read -rp "$(echo -e "${CYAN}Apply ML4W dotfiles? (y/N): ${RESET}")" dot_choice
  if [[ "$dot_choice" =~ ^[Yy]$ ]]; then
  curl -fsSL https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-arch.sh -o /tmp/ml4w.sh
  bash /tmp/ml4w.sh
  fi
}

install_cosmic() {
  print_section "Cosmic Alpha"
  start_point
  install_packages cosmic-session-git linux-headers pacman-contrib xdg-user-dirs switcheroo-control \
  xdg-desktop-portal-cosmic-git xorg-xwayland just mold cosmic-edit-git cosmic-files-git \
  cosmic-store-git cosmic-term-git cosmic-wallpapers-git wayland-protocols wayland-utils \
  lib32-wayland system76-power system-config-printer clipboard-manager-git cosmic-randr-git \
  cosmic-player-git cosmic-ext-applet-external-monitor-brightness-git cosmic-ext-forecast-git \
  cosmic-ext-tweaks-git cosmic-screenshot-git cosmic-applet-arch
  pacman -Rdd --noconfirm cosmic-store-git
  xdg-user-dirs-update
  echo
  sudo systemctl enable cosmic-greeter.service com.system76.PowerDaemon.service 2>/dev/null || echo -e "${YELLOW}cosmic-greeter.service not found.${RESET}"
}

post_install() {
  print_section "Post-Install Setup"
  echo "Installing Bluetooth and Utilities..."
  install_packages bluez bluez-utils bluez-plugins bluez-hid2hci bluez-cups bluez-libs bluez-tools
  sudo systemctl enable bluetooth.service

  echo "Installing other useful applications..."
  install_packages downgrade brightnessctl mkinitcpio-firmware update-grub meld timeshift mpv \
  gnome-disk-utility btop git rustup eza ntp most wget dnsutils logrotate gtk-update-icon-cache dex \
  bash-completion bat bat-extras ttf-fira-code otf-libertinus tex-gyre-fonts ttf-hack-nerd \
  ttf-ubuntu-font-family awesome-terminal-fonts ttf-jetbrains-mono-nerd adobe-source-sans-pro-fonts \
  gtk-engines gtk-engine-murrine gnome-themes-extra ntfs-3g gvfs mtpfs udiskie udisks2 ldmtool \
  gvfs-afc gvfs-mtp gvfs-nfs gvfs-smb gvfs-gphoto2 libgsf tumbler freetype2 libopenraw ffmpegthumbnailer \
  python-pip python-cffi python-numpy python-docopt python-pyaudio python-pyparted python-pygments \
  python-websockets ocs-url xmlstarlet yt-dlp wavpack unarchiver gnustep-base parallel systemdgenie \
  gnome-keyring ark vi duf gcc yad zip xdo lzop nmon tree vala htop lshw cblas expac fuse3 lhasa meson \
  unace rhash sshfs vnstat nodejs cronie hwinfo arandr assimp netpbm wmctrl grsync libmtp sysprof \
  semver zenity gparted hddtemp mlocate jsoncpp fuseiso gettext node-gyp graphviz pkgstats inetutils \
  s3fs-fuse playerctl oniguruma cifs-utils lsb-release dbus-python laptop-detect perl-xml-parser preload
  sudo systemctl enable preload

    echo "Installing GRUB & updating bootloader..."
  if command -v grub-mkconfig &> /dev/null; then
    install_packages os-prober grub-hooks update-grub
    sed -i 's/#\s*GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
    os-prober
    grub-mkconfig -o /boot/grub/grub.cfg
  fi

  echo "Detecting if you are in a VM..."
  case $(systemd-detect-virt) in
    oracle) install_packages virtualbox-guest-utils ;;
    kvm) install_packages qemu-guest-agent spice-vdagent ;;
    vmware)
      install_packages xf86-video-vmware open-vm-tools xf86-input-vmmouse
      systemctl enable vmtoolsd.service ;;
    wsl)
      echo -e "${YELLOW}WSL detected – limited support.${RESET}" ;;
  esac

}

# Menu stub
main_menu() {
  echo -e "${BOLD}${CYAN}Choose a Desktop Environment:${RESET}"
  echo -e "${GREEN}"
  echo    " 1) 🧊  Plasma"
  echo    " 2) 🌈  GNOME"

  echo    " 3) 🐭  XFCE"
  echo    " 4) 💥  Hyprland"
  echo    " 5) 🌌  Cosmic Alpha"
  echo
  echo    " 6) ❌  Exit"
  echo
  read -rp "Enter your choice [1-6] : " choice
  case "$choice" in
    1) check_gpu_compatibility plasma && start_point && install_plasma ;;
    2) check_gpu_compatibility gnome && start_point && install_gnome ;;
    3) check_gpu_compatibility xfce && start_point && install_xfce ;;
    4)
      echo -e "${YELLOW}"
      figlet -f small "⚠ VM Warning"
      echo -e "If you are running this in a VM, make sure 3D acceleration is enabled & supported.${RESET}"
      check_gpu_compatibility hyprland
      start_point
      install_hypr
      ;;
    5)
      echo -e "${YELLOW}"
      figlet -f small "⚠ VM Warning"
      echo -e "If you are running this in a VM, make sure 3D acceleration is enabled & supported."
      echo
      echo -e "${RED}"
      figlet -f small "❗ Alpha Warning"
      echo -e "Cosmic Alpha is still in development."
      echo -e "Do NOT install on a production machine."
      echo -e "Install AT YOUR OWN RISK!"
      echo -e "${RESET}"
      check_gpu_compatibility cosmic
      start_point
      install_cosmic
      ;;
    6) echo -e "${GREEN}Exiting. Have a nice day!${RESET}"; exit 0 ;;
    *) echo -e "${RED}Invalid choice. Exiting.${RESET}"; exit 1 ;;
  esac
}

main() {
  print_title
  check_vanilla_arch
  check_existing_de

    # Ensure figlet is installed early for banner output
  if ! command -v figlet &>/dev/null; then
  echo -e "${YELLOW}Installing 'figlet' for banner display...${RESET}"
  sudo pacman -S --noconfirm --needed figlet &>/dev/null && \
    echo -e "${GREEN}[✔] figlet installed.${RESET}" || \
    echo -e "${RED}[✘] Failed to install figlet.${RESET}"
fi

  main_menu
  post_install
  echo -e "${GREEN}✔ Done! You may now reboot into your desktop environment.${RESET}"
  read -rp "Press Enter to reboot now or Ctrl+C to cancel..."
  reboot
}

run() {
  trap 'echo -e "${RED}An error occurred. Exiting...${RESET}"; exit 1' ERR
  main "$@"
}

run "$@"

#!/usr/bin/env bash

set -euo pipefail

# -------------------------------------------------------------------------------------------------
# XeroLinux 5-in-1 Mega Installer: Plasma, GNOME, XFCE, Cosmic, Hyprland
# Author: DarkXero | Adapted by Claude for unified install
# -------------------------------------------------------------------------------------------------

# Root and Arch checks
if [ "$EUID" -ne 0 ]; then
  dialog --title "!! Error !!" --colors --msgbox "\nThis script must be run as \Zb\Z4root\Zn post-minimal \Zb\Z1ArchInstall\Zn.\n\nHit OK to exit." 10 60
  exit 1
fi

if ! grep -q "Arch Linux" /etc/os-release; then
  dialog --title "!! Unsupported OS !!" --colors --msgbox "\nThis script must be run on \Zb\Z1Vanilla Arch\Zn only.\n\nHit OK to exit." 10 60
  exit 1
fi

if ! command -v dialog &> /dev/null || { [ -z "${DISPLAY:-}" ] && [ ! -t 1 ]; }; then
  echo "Dialog cannot run in this environment (headless or missing TTY). Exiting."
  exit 1
fi

# Logging
exec > >(tee -i /var/log/xero-install.log)
exec 2>&1

# Install required tools
if ! command -v dialog &> /dev/null || ! command -v wget &> /dev/null; then
  echo "Installing missing tools (dialog, wget)..."
  pacman -Syy --noconfirm dialog wget
fi

# Helper functions
install_packages() {
  pacman -S --needed --noconfirm "$@"
}

fetch_base_config() {
  echo "Fetching XeroLinux base configuration..."
  curl -fsSL https://xerolinux.xyz/script/xapi.sh -o /tmp/xapi.sh
  bash /tmp/xapi.sh
}

# Show main DE selection menu
main_menu() {
  CHOICE=$(dialog --stdout --title ">> XeroLinux Desktop Installer <<" --menu "
Choose Desktop Environment to install:" 15 60 6 \
    1 "KDE Plasma" \
    2 "GNOME" \
    3 "XFCE" \
    4 "Hyprland" \
    5 "Cosmic Alpha" \
    6 "Exit") || CHOICE=""

  case "${CHOICE:-}" in
    1) install_plasma ;;
    2) install_gnome ;;
    3) install_xfce ;;
    4) install_hypr ;;
    5) install_cosmic ;;
    6) clear; echo "Goodbye!"; exit 0 ;;
    *) clear; dialog --msgbox "Invalid option." 10 40; main_menu ;;
  esac
}

# PLASMA
install_plasma() {
  fetch_base_config
  install_packages linux-headers nano kf6 power-profiles-daemon jq xmlstarlet unrar zip unzip 7zip qt6-3d qt6-5compat qt6-base qt6-charts qt6-connectivity qt6-declarative qt6-graphs qt6-grpc qt6-httpserver qt6-imageformats qt6-languageserver qt6-location qt6-lottie qt6-multimedia qt6-networkauth qt6-positioning qt6-quick3d qt6-quick3dphysics qt6-quickeffectmaker qt6-quicktimeline qt6-remoteobjects qt6-scxml qt6-sensors qt6-serialbus qt6-serialport qt6-shadertools qt6-speech qt6-svg qt6-tools qt6-translations qt6-virtualkeyboard qt6-wayland qt6-webchannel qt6-webengine qt6-websockets qt6-webview plasma-desktop packagekit-qt6 packagekit dolphin kcron khelpcenter kio-admin ksystemlog breeze plasma-workspace plasma-workspace-wallpapers powerdevil plasma-nm kaccounts-integration kdeplasma-addons plasma-pa plasma-integration plasma-browser-integration plasma-wayland-protocols plasma-systemmonitor kpipewire keysmith krecorder kweather plasmatube plasma-pass ocean-sound-theme qqc2-breeze-style plasma5-integration kdeconnect kdenetwork-filesharing kget kio-extras kio-gdrive kio-zeroconf colord-kde gwenview kamera kcolorchooser kdegraphics-thumbnailers kimagemapeditor kolourpaint okular spectacle svgpart ark kate kcalc kcharselect kdebugsettings kdf kdialog keditbookmarks kfind kgpg konsole markdownpart yakuake audiotube elisa ffmpegthumbs plasmatube dolphin-plugins pim-data-exporter pim-sieve-editor emoji-font gcc-libs glibc icu kauth kbookmarks kcmutils kcodecs kcompletion kconfig kconfigwidgets kcoreaddons kcrash kdbusaddons kdeclarative kglobalaccel kguiaddons ki18n kiconthemes kio kirigami kirigami-addons kitemmodels kitemviews kjobwidgets kmenuedit knewstuff knotifications knotifyconfig kpackage krunner kservice ksvg kwidgetsaddons kwindowsystem kxmlgui libcanberra libksysguard libplasma libx11 libxcb libxcursor libxi libxkbcommon libxkbfile plasma-activities plasma-activities-stats plasma5support polkit polkit-kde-agent qt6-5compat qt6-base qt6-declarative qt6-wayland sdl2 solid sonnet systemsettings wayland xcb-util-keysyms xdg-user-dirs scim extra-cmake-modules intltool wayland-protocols xf86-input-libinput sddm-kcm bluedevil breeze-gtk drkonqi kde-gtk-config kdeplasma-addons kinfocenter kscreen ksshaskpass oxygen oxygen-sounds xdg-desktop-portal-kde breeze-grub flatpak-kcm networkmanager-qt quota-tools qt5-x11extras gpsd pacman-contrib cmake falkon
  systemctl enable sddm.service 2>/dev/null || echo "Warning: sddm.service not found."
  systemctl enable power-profiles-daemon.service
  clear
}

# GNOME
install_gnome() {
  fetch_base_config
  install_packages linux-headers evince extension-manager epiphany gdm gnome-subtitles gnac gmtk gnome-backgrounds gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-color-manager gnome-connections gnome-terminal-transparency gnome-contacts gnome-control-center gnome-disk-utility gnome-font-viewer gnome-gesture-improvements gnome-keyring gnome-logs gnome-maps gnome-menus gnome-network-displays gnome-remote-desktop gnome-session gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-system-monitor gnome-text-editor gnome-themes-extra gnome-tweaks gnome-user-share gnome-weather grilo-plugins gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd loupe nautilus rygel power-profiles-daemon simple-scan snapshot sushi tecla totem xdg-desktop-portal-gnome xdg-user-dirs-gtk nano jq xmlstarlet unrar zip unzip 7zip libadwaita adwaita-fonts adwaita-cursors adwaita-icon-theme adwaita-icon-theme-legacy
  systemctl enable gdm.service 2>/dev/null || echo "Warning: gdm.service not found."
  systemctl enable power-profiles-daemon.service
  clear
}

# XFCE
install_xfce() {
  fetch_base_config
  install_packages linux-headers nano xfce4 epiphany mousepad parole ristretto thunar-archive-plugin thunar-media-tags-plugin xfburn xfce4-artwork xfce4-battery-plugin xfce4-clipman-plugin xfce4-cpufreq-plugin xfce4-cpugraph-plugin xfce4-dict xfce4-diskperf-plugin xfce4-eyes-plugin xfce4-fsguard-plugin xfce4-genmon-plugin xfce4-mailwatch-plugin xfce4-mount-plugin xfce4-mpc-plugin xfce4-netload-plugin xfce4-notes-plugin xfce4-notifyd xfce4-places-plugin xfce4-pulseaudio-plugin xfce4-screensaver xfce4-screenshooter xfce4-sensors-plugin xfce4-smartbookmark-plugin xfce4-systemload-plugin xfce4-taskmanager xfce4-time-out-plugin xfce4-timer-plugin xfce4-verve-plugin xfce4-wavelan-plugin xfce4-weather-plugin xfce4-whiskermenu-plugin xfce4-xkb-plugin lightdm lightdm-gtk-greeter power-profiles-daemon unrar zip unzip 7zip
  systemctl enable lightdm.service 2>/dev/null || echo "Warning: lightdm.service not found."
  systemctl enable power-profiles-daemon.service
  clear
}

# GPU check and dialog wrapper
gpu_check_dialog() {
  local TITLE=$1
  local MSG=$2
  clear
  dialog --title "$TITLE" --colors --yesno "$MSG\n\n\Zb\Z6Proceed at your OWN RISK!.\Zn" 0 0 || exit 1
}

# COSMIC
install_cosmic() {
  fetch_base_config
  install_packages cosmic-session-git linux-headers pacman-contrib xdg-user-dirs switcheroo-control xdg-desktop-portal-cosmic-git xorg-xwayland just mold cosmic-edit-git cosmic-files-git cosmic-store-git cosmic-term-git cosmic-wallpapers-git wayland-protocols wayland-utils lib32-wayland system76-power system-config-printer clipboard-manager-git cosmic-randr-git cosmic-player-git cosmic-ext-applet-external-monitor-brightness-git cosmic-ext-forecast-git cosmic-ext-tweaks-git cosmic-screenshot-git cosmic-applet-arch
  pacman -Rdd --noconfirm cosmic-store-git
  systemctl enable cosmic-greeter.service 2>/dev/null || echo "Warning: cosmic-greeter.service not found."
  systemctl enable com.system76.PowerDaemon.service && xdg-user-dirs-update
  clear
}

# HYPRLAND
install_hypr() {
  check_gpu "Hyprland WM" "Your GPU will be tested for Hyprland compatibility..."
  fetch_base_config
  install_packages hyprland hypridle hyprland-protocols hyprlock hyprpaper hyprpicker hyprpolkitagent hyprsunset linux-headers pacman-contrib xdg-desktop-portal-hyprland xdg-user-dirs power-profiles-daemon nwg-displays
  xdg-user-dirs-update && systemctl enable power-profiles-daemon.service
  clear
  dialog --title "ML4W Dot Files" --colors --yesno "\nDo you want to apply \Zb\Z1ML4W\Zn dot files?" 0 0 && {
    curl -fsSL https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-arch.sh -o /tmp/ml4w.sh
    bash /tmp/ml4w.sh && install_packages nwg-displays
  }
  clear
}

# GPU check logic
check_gpu() {
  local TITLE="$1"
  local NOTE="$2"
  local INFO=$(lspci | grep -E "VGA|3D")
  local OK=false
  echo "$NOTE"
  if echo "$INFO" | grep -qi "NVIDIA"; then
    echo "$INFO" | grep -Eqi "GTX (9[0-9]{2}|[1-9][0-9]{3})|RTX|Titan|A[0-9]{2,3}" && OK=true
  elif echo "$INFO" | grep -qi "Intel"; then
    echo "$INFO" | grep -Eqi "HD Graphics ([4-9][0-9]{2,3}|[1-9][0-9]{4,})|Iris|Xe" && OK=true
  elif echo "$INFO" | grep -qi "AMD"; then
    echo "$INFO" | grep -Eqi "RX (4[8-9][0-9]|[5-9][0-9]{2,3})|VEGA|RDNA|RADEON PRO" && OK=true
  fi
  gpu_check_dialog "$TITLE Compatibility" "Detected GPU:\n$INFO\n\n$([[ \"$OK\" == true ]] && echo 'Compatible GPU.' || echo 'Unknown GPU.\nLimited support. If in VM, ensure 3D acceleration is enabled via VirtGL.')"
}

# Shared post-install
post_install() {
  echo "Installing Bluetooth and Utilities..."
  install_packages bluez bluez-utils bluez-plugins bluez-hid2hci bluez-cups bluez-libs bluez-tools
  systemctl enable bluetooth.service

  echo "Installing other useful applications..."
  install_packages downgrade brightnessctl mkinitcpio-firmware update-grub meld timeshift mpv gnome-disk-utility btop git rustup eza ntp most wget dnsutils logrotate gtk-update-icon-cache dex bash-completion bat bat-extras ttf-fira-code otf-libertinus tex-gyre-fonts ttf-hack-nerd ttf-ubuntu-font-family awesome-terminal-fonts ttf-jetbrains-mono-nerd adobe-source-sans-pro-fonts gtk-engines gtk-engine-murrine gnome-themes-extra ntfs-3g gvfs mtpfs udiskie udisks2 ldmtool gvfs-afc gvfs-mtp gvfs-nfs gvfs-smb gvfs-gphoto2 libgsf tumbler freetype2 libopenraw ffmpegthumbnailer python-pip python-cffi python-numpy python-docopt python-pyaudio python-pyparted python-pygments python-websockets ocs-url xmlstarlet yt-dlp wavpack unarchiver gnustep-base parallel systemdgenie gnome-keyring ark vi duf gcc yad zip xdo lzop nmon tree vala htop lshw cblas expac fuse3 lhasa meson unace rhash sshfs vnstat nodejs cronie hwinfo arandr assimp netpbm wmctrl grsync libmtp sysprof semver zenity gparted hddtemp mlocate jsoncpp fuseiso gettext node-gyp graphviz pkgstats inetutils s3fs-fuse playerctl oniguruma cifs-utils lsb-release dbus-python laptop-detect perl-xml-parser preload
  systemctl enable preload
  
  echo "Installing GRUB & Utilities..."
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
    vmware) install_packages xf86-video-vmware open-vm-tools xf86-input-vmmouse && systemctl enable vmtoolsd.service ;;
    wsl) echo "WSL detected – limited support." ;;
  esac
}

# Run main flow
main_menu
post_install
clear
dialog --title "Installation Complete" --msgbox "\nInstallation Complete. You may now exit chroot and reboot.\n\nFind 'xero-cli' in the AppMenu for tools and tweaks!" 10 50
clear; echo "Type exit to leave chroot and reboot."

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

# Install required tools
if ! command -v dialog &> /dev/null || ! command -v wget &> /dev/null; then
  echo "Installing missing tools (dialog, wget)..."
  pacman -Syy --noconfirm dialog wget
fi

# Show main DE selection menu
main_menu() {
  CHOICE=$(dialog --stdout --title ">> XeroLinux Mega Installer <<" --menu "\nChoose Desktop Environment to install:" 15 60 6 \
    1 "Plasma Desktop" \
    2 "GNOME Desktop" \
    3 "XFCE Desktop" \
    4 "Hyprland WM" \
    5 "install_cosmic"
    6 "Exit")

  case "$CHOICE" in
    1) install_plasma ;;
    2) install_gnome ;;
    3) install_xfce ;;
    4) install_hypr ;;
    5) install_cosmic ;;
    6) clear; exit 0 ;;
    *) dialog --msgbox "Invalid option." 10 40; main_menu ;;
  esac
}

# Helper function
install_packages() {
  pacman -S --needed --noconfirm $1
}

# PLASMA
install_plasma() {
  install_packages "linux-headers nano kf6 power-profiles-daemon jq xmlstarlet unrar zip unzip 7zip \
qt6-* plasma-desktop dolphin kcron plasma-nm kdeplasma-addons plasma-pa plasma-browser-integration plasma-systemmonitor \
kdeconnect gwenview kamera kolourpaint okular spectacle ark kate konsole yakuake elisa dolphin-plugins ffmpegthumbs \
xdg-user-dirs sddm-kcm bluedevil breeze-gtk kde-gtk-config kinfocenter kscreen ksshaskpass networkmanager-qt cmake falkon"
  systemctl enable sddm.service power-profiles-daemon.service
}

# GNOME
install_gnome() {
  install_packages "linux-headers evince extension-manager epiphany gdm gnome-shell gnome-control-center gnome-settings-daemon \
xdg-desktop-portal-gnome gnome-terminal-transparency gnome-weather nautilus power-profiles-daemon zip unzip 7zip libadwaita"
  systemctl enable gdm.service power-profiles-daemon.service
}

# XFCE
install_xfce() {
  install_packages "linux-headers nano xfce4 epiphany thunar-archive-plugin lightdm lightdm-gtk-greeter power-profiles-daemon zip unzip 7zip"
  systemctl enable lightdm.service power-profiles-daemon.service
}

# GPU check and dialog wrapper (shared)
gpu_check_dialog() {
  local TITLE=$1
  local MSG=$2
  dialog --title "$TITLE" --colors --yesno "$MSG\n\n\Zb\Z6Proceed at your OWN RISK!.\Zn" 0 0 || exit 1
}

# COSMIC
install_cosmic() {
  install_packages "cosmic-session-git linux-headers pacman-contrib xdg-user-dirs switcheroo-control xdg-desktop-portal-cosmic-git \
xorg-xwayland just mold cosmic-edit-git cosmic-files-git cosmic-store-git cosmic-term-git cosmic-wallpapers-git \
clipboard-manager-git cosmic-randr-git cosmic-player-git cosmic-ext-applet-external-monitor-brightness-git \
cosmic-ext-forecast-git cosmic-ext-tweaks-git cosmic-screenshot-git cosmic-applet-arch" 
  pacman -Rdd --noconfirm cosmic-store-git
  systemctl enable cosmic-greeter.service com.system76.PowerDaemon.service
}

# HYPRLAND
install_hypr() {
  check_gpu "Hyprland WM" "Your GPU will be tested for Hyprland compatibility..."
  curl -fsSL https://xerolinux.xyz/script/xapi.sh | bash
  install_packages "hyprland hypridle hyprland-protocols hyprlock hyprpaper hyprpicker hyprpolkitagent hyprsunset \
linux-headers pacman-contrib xdg-desktop-portal-hyprland xdg-user-dirs power-profiles-daemon"
  xdg-user-dirs-update
  systemctl enable power-profiles-daemon.service
  dialog --title "ML4W Dot Files" --colors --yesno "\nDo you want to apply \Zb\Z1ML4W\Zn dot files?" 0 0 && curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-arch.sh | bash && install_packages "nwg-displays"
}

# GPU check logic (shared)
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
  gpu_check_dialog "$TITLE Compatibility" "Detected GPU:\n$INFO\n\n$([[ "$OK" == true ]] && echo 'Compatible GPU.' || echo 'Compatibility uncertain.')"
}

# Shared post-install
post_install() {
  echo "Installing Bluetooth and Utilities..."
  install_packages "bluez bluez-utils bluez-plugins bluez-hid2hci bluez-cups bluez-libs bluez-tools"
  systemctl enable bluetooth.service

  echo "Installing GRUB & Utilities..."
  if command -v grub-mkconfig &> /dev/null; then
    install_packages "os-prober grub-hooks update-grub"
    sed -i 's/#\s*GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
    os-prober
    grub-mkconfig -o /boot/grub/grub.cfg
  fi

  echo "Detecting if you are in a VM..."
  case $(systemd-detect-virt) in
    oracle) install_packages "virtualbox-guest-utils" ;;
    kvm) install_packages "qemu-guest-agent spice-vdagent" ;;
    vmware) install_packages "xf86-video-vmware open-vm-tools xf86-input-vmmouse" && systemctl enable vmtoolsd.service ;;
  esac
}

# Run main flow
main_menu
post_install

dialog --title "Installation Complete" --msgbox "\nInstallation Complete. You may now exit chroot and reboot.\n\nFind 'xero-cli' in the AppMenu for tools and tweaks!" 10 50
clear; echo "Type exit to leave chroot and reboot."

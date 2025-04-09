#!/usr/bin/env bash

##################################################################################################################
# Author : DarkXero
# Website : https://xerolinux.xyz
# To be used in Arch-Chroot (After installing Base packages via ArchInstall)
##################################################################################################################

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo
  dialog --title "!! Error !!" --colors --msgbox "\nThis script must be run as \Zb\Z4root\Zn. Please re-run the script with elevated privileges using \Zb\Z1sudo\Zn or as root.\n\nHit OK to exit." 10 60
  echo
  exit 1
fi

# Check if the script is running on Arch Linux
 if ! grep -q "Arch Linux" /etc/os-release; then
   dialog --title "!! Unknown/Custom Distro !!" --colors --msgbox "\nThis script must be run on \Zb\Z1Vanilla Arch\Zn. Running it on any other Distro, even \Zb\Z6Arch-Spins\Zn might cause issues.\n\nHit OK to exit." 10 0
   exit 1
 fi

# Check if dialog is installed, if not, install it
if ! command -v dialog &> /dev/null; then
  echo
  echo "dialog is not installed. Installing dialog..."
  pacman -Syy --noconfirm dialog
fi

# Function to display a dialog and handle user response
show_dialog() {
    dialog --title "Hyprland Compatibility Check" --colors --yesno "$1 Doing so will add the \Zb\Z1XeroLinux\Zn and \Zb\Z6Chaotic-AUR\Zn repos.\n\n\Zb\Z6Proceed at your OWN RISK!.\Zn" 13 69
    response=$?
    if [ $response -eq 0 ]; then
        echo
        clear && echo "Proceeding with the installation..."
        sleep 3
        return 0
    else
        echo
        clear && echo "Canceling the installation..."
        echo
        sleep 3
        exit 1
    fi
}

# Function to determine GPU compatibility for Wayland
check_gpu_compatibility() {
    if command -v lspci &> /dev/null; then
        GPU_INFO=$(lspci | grep -E "VGA|3D")

        if echo "$GPU_INFO" | grep -qi "NVIDIA"; then
            # Check for NVIDIA GPU compatibility (900 series and up)
            if echo "$GPU_INFO" | grep -Eqi "GTX (9[0-9]{2}|[1-9][0-9]{3})|RTX|Titan|A[0-9]{2,3}"; then
                show_dialog "\n\nYour \Zb\Z6nVidia\Zn GPU should support \Zb\Z1Hyprland WM\Zn, do you want to proceed?"
            else
                show_dialog "\n\nOlder \Zb\Z6nVidia\Zn GPU detected. Only 900 series and later support \Zb\Z1Hyprland WM\Zn."
            fi
        elif echo "$GPU_INFO" | grep -qi "Intel"; then
            # Check for Intel GPU compatibility (HD Graphics 4000 series and newer)
            if echo "$GPU_INFO" | grep -Eqi "HD Graphics ([4-9][0-9]{2,3}|[1-9][0-9]{4,})|Iris|Xe"; then
                show_dialog "\n\nYour \Zb\Z6Intel\Zn GPU should support \Zb\Z1Hyprland WM\Zn, do you want to proceed?"
            else
                show_dialog "\n\nOlder \Zb\Z6Intel\Zn GPU detected. Only HD Graphics 4000 series and newer support \Zb\Z1Hyprland WM\Zn."
            fi
        elif echo "$GPU_INFO" | grep -qi "AMD"; then
            # Check for AMD GPU compatibility (RX 480 and newer)
            if echo "$GPU_INFO" | grep -Eqi "RX (4[8-9][0-9]|[5-9][0-9]{2,3})|VEGA|RDNA|RADEON PRO"; then
                show_dialog "\n\nYour \Zb\Z6AMD\Zn GPU should support \Zb\Z1Hyprland WM\Zn, do you want to proceed?"
            else
                show_dialog "\n\nOlder \Zb\Z6AMD\Zn GPU detected. Only RX 480 and newer support \Zb\Z1Hyprland WM\Zn."
            fi
        else
            show_dialog "\n\nUnknown or unsupported GPU detected. \Zb\Z1Hyprland WM\Zn compatibility is uncertain, do you want to proceed anyway?"
        fi
    else
        show_dialog "Cannot detect GPU. 'lspci' command not found."
    fi
}

# Main script execution
check_gpu_compatibility

# Run the command after the user clicks "OK"
bash -c "$(curl -fsSL https://xerolinux.xyz/script/xapi.sh)"
# Sleep for 3 seconds (if needed)
sleep 3

# If user agrees to proceed, run the rest of the installation steps
echo "Proceeding with the installation..."

# Function to install packages
install_packages() {
  packages=$1
  pacman -S --needed --noconfirm $packages
}

#Install Hyprland
clear && install_packages "hyprland hypridle hyprland-protocols hyprlock hyprpaper hyprpicker hyprpolkitagent hyprsunset linux-headers pacman-contrib xdg-desktop-portal-hyprland xdg-user-dirs power-profiles-daemon"

# Enable services after package installation
xdg-user-dirs-update && systemctl enable power-profiles-daemon.service
echo
echo "Installing Bluetooth packages..."
echo
install_packages "bluez bluez-utils bluez-plugins bluez-hid2hci bluez-cups bluez-libs bluez-tools"
systemctl enable bluetooth.service

echo
echo "Installing other useful applications..."
echo
install_packages "downgrade update-grub meld timeshift mpv gnome-disk-utility btop nano git rustup eza ntp most wget dnsutils logrotate gtk-update-icon-cache dex bash-completion bat bat-extras ttf-fira-code otf-libertinus tex-gyre-fonts ttf-hack-nerd ttf-ubuntu-font-family awesome-terminal-fonts ttf-jetbrains-mono-nerd adobe-source-sans-pro-fonts gtk-engines gtk-engine-murrine gnome-themes-extra ntfs-3g gvfs mtpfs udiskie udisks2 ldmtool gvfs-afc gvfs-mtp gvfs-nfs gvfs-smb gvfs-gphoto2 libgsf tumbler freetype2 libopenraw ffmpegthumbnailer python-pip python-cffi python-numpy python-docopt python-pyaudio python-pyparted python-pygments python-websockets ocs-url xmlstarlet yt-dlp wavpack unarchiver gnustep-base parallel systemdgenie gnome-keyring ark vi duf gcc yad zip xdo lzop nmon tree vala htop lshw cmake cblas expac fuse3 lhasa meson unace unrar unzip p7zip rhash sshfs vnstat nodejs cronie hwinfo arandr assimp netpbm wmctrl grsync libmtp polkit sysprof semver zenity gparted hddtemp mlocate jsoncpp fuseiso gettext node-gyp intltool graphviz pkgstats inetutils s3fs-fuse playerctl oniguruma cifs-utils lsb-release dbus-python laptop-detect perl-xml-parser appmenu-gtk-module"

# Check if GRUB is installed
if command -v grub-mkconfig &> /dev/null; then
    echo "GRUB is installed. Adding support for OS-Prober."

    # Install os-prober
    install_packages "os-prober"

    # Enable OS Prober in GRUB configuration
    sudo sed -i 's/#\s*GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' '/etc/default/grub'

    # Run os-prober and update GRUB configuration
    sudo os-prober
    sudo grub-mkconfig -o /boot/grub/grub.cfg
else
    echo "GRUB is not installed. Skipping OS-Prober support addition."
fi

  # Prompt user for input
  dialog --title "ML4W Dot Files" --colors --yesno "\nDo you want to apply \Zb\Z1ML4W\Zn dot files? Selecting 'Yes' will execute the Setup script from source. Selecting 'No' will result in a bone stock install.\n\nHit Yes or No to continue." 10 60
  
  # Capture the exit status of dialog (0 for Yes, 1 for No)
  response=$?
  
  if [ "$response" -eq 0 ]; then
    echo "Applying ML4W dot files..."
    bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-arch.sh)
    install_packages "nwg-displays"
  else
    echo "Skipping ML4W dot files setup."
  fi

dialog --title "Installation Complete" --msgbox "\nInstallation Complete. Now exit and reboot.\n\nFor further customization, please find our Toolkit in AppMenu under System or by typing xero-cli in terminal." 12 50

# Exit chroot and reboot
clear
echo "Type exit to exit chroot environment and reboot system..."
sleep 3

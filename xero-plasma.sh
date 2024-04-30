#!/bin/bash
#
##################################################################################################################
# Author    : DarkXero
# Website   : https://xerolinux.xyz
# To be used in Arch-Chroot (After installing Base packages via ArchInstall)
##################################################################################################################

echo
echo "############################################"
echo "             KDE-Plasma Install             "
echo "############################################"
echo
echo "This is where you choose how to install Plasma."
echo "------------------------------------------------"
echo
echo "1. Minimal   : Minimal install. (ArchInstall method)."
echo "2. Complete  : Full install, includes everything. (Bloated)."
echo "3. XeroLinux : Curated set of Plasma packages (Best for all systems)."
echo "4. Selective : Allows you to select individual packages. (Advanced Users)."
echo

read -p "Enter your choice [1-4]: " choice

case $choice in
  1)
    pacman -S --needed --noconfirm plasma-meta konsole kate dolphin ark plasma-workspace egl-wayland falkon
    ;;
  2)
    pacman -S --needed --noconfirm kf6 qt6 plasma-meta kde-applications-meta kdeconnect packagekit-qt6 kde-cli-tools kdeplasma-addons plasma-activities polkit-kde-agent flatpak-kcm bluedevil glib2 ibus kaccounts-integration kscreen libaccounts-qt plasma-nm plasma-pa scim extra-cmake-modules kaccounts-integration kdoctools libibus wayland-protocols plasma-applet-window-buttons plasma-workspace appmenu-gtk-module kwayland-integration plasma5-integration xdg-desktop-portal-gtk
    ;;
  3)
    pacman -S --needed --noconfirm kf6 qt6 jq xmlstarlet plasma-desktop packagekit-qt6 packagekit dolphin kcron khelpcenter kio-admin ksystemlog breeze discover plasma-workspace plasma-workspace-wallpapers powerdevil plasma-nm kaccounts-integration kdeplasma-addons plasma-pa plasma-integration plasma-browser-integration plasma-wayland-protocols plasma-systemmonitor kpipewire keysmith krecorder kweather plasmatube plasma-pass ocean-sound-theme qqc2-breeze-style plasma5-integration kdeconnect kdenetwork-filesharing kget kio-extras kio-gdrive kio-zeroconf colord-kde gwenview kamera kcolorchooser kdegraphics-thumbnailers kimagemapeditor kolourpaint okular spectacle svgpart ark kate kcalc kcharselect kdebugsettings kdf kdialog keditbookmarks kfind kgpg konsole markdownpart yakuake audiotube elisa ffmpegthumbs plasmatube dolphin-plugins pim-data-exporter pim-sieve-editor emoji-font ttf-joypixels gcc-libs glibc icu kauth kbookmarks kcmutils kcodecs kcompletion kconfig kconfigwidgets kcoreaddons kcrash kdbusaddons kdeclarative kglobalaccel kguiaddons ki18n kiconthemes kio kirigami kirigami-addons kitemmodels kitemviews kjobwidgets kmenuedit knewstuff knotifications knotifyconfig kpackage krunner kservice ksvg kwidgetsaddons kwindowsystem kxmlgui libcanberra libksysguard  libplasma libx11 libxcb libxcursor libxi libxkbcommon libxkbfile plasma-activities plasma-activities-stats plasma5support polkit-kde-agent qt6-5compat qt6-base qt6-declarative qt6-wayland sdl2 solid sonnet systemsettings wayland xcb-util-keysyms xdg-user-dirs scim extra-cmake-modules intltool wayland-protocols xf86-input-libinput sddm-kcm bluedevil breeze-gtk drkonqi kde-gtk-config kdeplasma-addons kinfocenter kscreen ksshaskpass oxygen oxygen-sounds xdg-desktop-portal-kde breeze-grub flatpak-kcm falkon
    ;;
  4)
    pacman -S --needed kf6 qt6 plasma-meta kde-applications-meta kdeconnect packagekit-qt6 kde-cli-tools kdeplasma-addons plasma-activities polkit-kde-agent flatpak-kcm bluedevil glib2 ibus kaccounts-integration kscreen libaccounts-qt plasma-nm plasma-pa scim extra-cmake-modules kaccounts-integration kdoctools libibus wayland-protocols plasma-applet-window-buttons plasma-workspace appmenu-gtk-module kwayland-integration plasma5-integration xdg-desktop-portal-gtk
    ;;
  *)
    echo "Invalid option. Please select 1, 2, 3 or 4."
    ;;
esac

echo
echo "Activating SDDM..."
echo
systemctl enable sddm.service
echo
sleep 3
echo "#############################################"
echo "           Installing nVidia Drivers         "
echo "    Not for Hybrid only Single Modern GPU    "
echo "#############################################"
echo
pacman -S --noconfirm --needed linux-headers nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau
echo
echo "Configuring for Wayland..."
echo
sed -i '/^MODULES=(/ s/)$/ nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf && mkinitcpio -P
sleep 3
systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service nvidia-powerd.service
sleep 3
echo -e 'options nvidia NVreg_UsePageAttributeTable=1 NVreg_InitializeSystemMemoryAllocations=0 NVreg_DynamicPowerManagement=0x02' | tee -a /etc/modprobe.d/nvidia.conf
echo -e 'options nvidia_drm modeset=1 fbdev=1' | tee -a /etc/modprobe.d/nvidia.conf
sleep 3
echo
echo "##############################################"
echo "   Adding XeroLinux Repo, Bluetooth & More.   "
echo "##############################################"
echo
echo "Adding XeroLinux Repository..."
echo
echo -e '\n[xerolinux]\nSigLevel = Optional TrustAll\nServer = https://repos.xerolinux.xyz/$repo/$arch' | tee -a /etc/pacman.conf
sed -i '/^\s*#\s*\[multilib\]/,/^$/ s/^#//' /etc/pacman.conf
echo
echo "Installing Paru/Toolkit..."
echo
pacman -Syyu --noconfirm paru-bin xlapit-cli
echo
echo "Installing PipeWire packages..."
echo
pacman -S --needed --noconfirm gstreamer gst-libav gst-plugins-bad gst-plugins-base gst-plugins-ugly gst-plugins-good libdvdcss alsa-utils alsa-firmware pavucontrol lib32-pipewire-jack libpipewire pipewire-v4l2 pipewire-x11-bell pipewire-zeroconf realtime-privileges sof-firmware ffmpeg ffmpegthumbs ffnvcodec-headers
echo
echo "Installing Bluetooth packages..."
echo
pacman -S --needed --noconfirm bluez bluez-utils bluez-plugins bluez-hid2hci bluez-cups bluez-libs bluez-tools
systemctl enable bluetooth.service
echo
echo "Adding support for OS-Prober"
echo
pacman -S --noconfirm --needed os-prober
sed -i 's/#\s*GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' '/etc/default/grub'
os-prober
grub-mkconfig -o /boot/grub/grub.cfg
echo
sleep 3
echo
echo "Installing other useful applications..."
echo
pacman -S --needed --noconfirm meld timeshift elisa mpv gparted gnome-disk-utility wine-meta xero-fix-scripts xero-hooks
echo
grub-mkconfig -o /boot/grub/grub.cfg
echo
sleep 3
echo "#############################################"
echo "           Done, now exit and reboot          "
echo "#############################################"

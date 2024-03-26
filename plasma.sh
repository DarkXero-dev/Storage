#!/bin/bash
#
##################################################################################################################
# Author 	  : 	DarkXero
# Website 	: 	https://xerolinux.xyz
# To be used in Arch-Chroot (After installing Base packages via ArchInstall)
##################################################################################################################
echo
echo "#############################################"
echo "Plasma Package Groups Select needed packages."
echo "#############################################"
echo
sudo pacman -S --needed kf6 qt6 packagekit-qt6 packagekit kde-system plasma kde-network kde-graphics kde-utilities kde-multimedia kde-applications plasma-desktop plasma-meta plasma-workspace dolphin-plugins plasmatube audiotube ffmpegthumbs kirigami-gallery dwayland qt6-wayland lib32-wayland wayland-protocols kwayland-integration plasma-wayland-protocols kdecoration ksshaskpass kgpg
echo
echo "#############################################"
echo "    Plasma done, now on with next step...    "
echo "#############################################"
sleep 3
echo
echo "#############################################"
echo "               Starting SDDM...              "
echo "#############################################"
echo
systemctl enable sddm.service
sleep 3
echo
echo "#############################################"
echo "               Grabbing Toolkit              "
echo "#############################################"
echo
bash -c "$(curl -fsSL https://get.xerolinux.xyz/)"
sleep 3
echo
echo "#############################################"
echo "           Done, now exit n reboot           "
echo "#############################################"

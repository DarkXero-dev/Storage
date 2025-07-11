#!/bin/bash
#set -e
##################################################################################################################
# Author	:	DarkXero
# Website	:	https://xerolinux.xyz
##################################################################################################################

# Reset
Color_Off="\033[0m"       # Text Reset

# Regular Colors
Black="\033[0;30m"        # Black
Red="\033[0;31m"          # Red
Green="\033[0;32m"        # Green
Yellow="\033[0;33m"       # Yellow
Blue="\033[0;34m"         # Blue
Purple="\033[0;35m"       # Purple
Cyan="\033[0;36m"         # Cyan
White="\033[0;37m"        # White
NC='\033[0m'              # No Color

# Bold
BBlack="\033[1;30m"       # Black
BRed="\033[1;31m"         # Red
BGreen="\033[1;32m"       # Green
BYellow="\033[1;33m"      # Yellow
BBlue="\033[1;34m"        # Blue
BPurple="\033[1;35m"      # Purple
BCyan="\033[1;36m"        # Cyan
BWhite="\033[1;37m"       # White

# Underline
UBlack="\033[4;30m"       # Black
URed="\033[4;31m"         # Red
UGreen="\033[4;32m"       # Green
UYellow="\033[4;33m"      # Yellow
UBlue="\033[4;34m"        # Blue
UPurple="\033[4;35m"      # Purple
UCyan="\033[4;36m"        # Cyan
UWhite="\033[4;37m"       # White

# Background
On_Black="\033[40m"       # Black
On_Red="\033[41m"         # Red
On_Green="\033[42m"       # Green
On_Yellow="\033[43m"      # Yellow
On_Blue="\033[44m"        # Blue
On_Purple="\033[45m"      # Purple
On_Cyan="\033[46m"        # Cyan
On_White="\033[47m"       # White

# High Intensty
IBlack="\033[0;90m"       # Black
IRed="\033[0;91m"         # Red
IGreen="\033[0;92m"       # Green
IYellow="\033[0;93m"      # Yellow
IBlue="\033[0;94m"        # Blue
IPurple="\033[0;95m"      # Purple
ICyan="\033[0;96m"        # Cyan
IWhite="\033[0;97m"       # White

# Bold High Intensty
BIBlack="\033[1;90m"      # Black
BIRed="\033[1;91m"        # Red
BIGreen="\033[1;92m"      # Green
BIYellow="\033[1;93m"     # Yellow
BIBlue="\033[1;94m"       # Blue
BIPurple="\033[1;95m"     # Purple
BICyan="\033[1;96m"       # Cyan
BIWhite="\033[1;97m"      # White

# High Intensty backgrounds
On_IBlack="\033[0;100m"   # Black
On_IRed="\033[0;101m"     # Red
On_IGreen="\033[0;102m"   # Green
On_IYellow="\033[0;103m"  # Yellow
On_IBlue="\033[0;104m"    # Blue
On_IPurple="\033[10;95m"  # Purple
On_ICyan="\033[0;106m"    # Cyan
On_IWhite="\033[0;107m"   # White

# Various variables you might want for your PS1 prompt instead
Time12h="\T"
Time12a="\@"
PathShort="\w"
PathFull="\W"
NewLine="\n"
Jobs="\j"
clear
# ASCII Art for the script header
echo -e "${Blue}==============================================${NC}"
echo -e "${Yellow}  Welcome to the XeroLinux Project toolbox ! ${NC}"
echo -e "${Blue}==============================================${NC}"
echo
# Prompt user for input
echo -e "${Green}Hey $USER, what shall we do today ?${NC}"
echo
echo -e "${BIGreen}==> Toolkit Setup :${NC}"
echo
echo -e "1) Install Required Tools"
echo -e "2) Set up Packager in makepkg"
echo -e "3) Disable !debug build flag (Needed)"
echo
echo -e "${BIYellow}==> Git Repo Tools :${NC}"
echo
echo -e "4) Set up Git Credentials"
echo -e "5) Commit latest ISO changes"
echo -e "6) Reset Git Repo History (DANGER!)"
echo
echo -e "${BIPurple}==> The ISO Builder :${NC}"
echo
echo -e "k) Build XeroLinux KDE Flagship"
echo -e "g) Build XeroLinux Gnome Dev Spin"
echo -e "c) Build XeroLinux Cosmic Alpha Ed."
echo
echo -e "x) Cancel and Exit"

# Read user choice
echo
read -p "Please enter your choice : " choice

# Execute based on user input
case $choice in
    1)
        echo
        echo -e "${Blue}Install required tools.${NC}"
        echo
        sudo pacman -S --noconfirm --needed rustup repoctl cmake extra-cmake-modules
        rustup default nightly
        echo
        echo "Done, Builder apps have been installed !"
        sleep 3
        exit
        ;;
    2)
        echo
        echo -e "${Blue}Setting Packager Profile.${NC}"
        echo
        sudo cp /etc/makepkg.conf /etc/makepkg.conf.bak
        sudo sed -i 's/^#\?PACKAGER=.*/PACKAGER="DarkXero <info@techxero.com>"/' /etc/makepkg.conf
        echo
        echo "Done! Original file backed up as /etc/makepkg.conf.bak"
        sleep 5
        exit
        ;;
    3)
        echo
        echo -e "${Blue}Disabling !Debug Flag.${NC}"
        sleep 3
        echo
        read -rp "Are you sure you want to proceed? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            if ! sudo test -w "/etc/makepkg.conf"; then
                gum style --foreground 196 "Error: Cannot write to /etc/makepkg.conf. Are you root?"
                exit 1
            fi

            if grep -q "!debug lto" /etc/makepkg.conf; then
                echo
                gum style --foreground 7 "Debugging is already off - nothing to do"
            else
                echo
                gum style --foreground 7 "Disabling !debug"
                echo
                if ! sudo sed -i "s/debug lto/!debug lto/g" /etc/makepkg.conf; then
                    gum style --foreground 196 "Failed to modify makepkg.conf"
                    exit 1
                fi
                gum style --foreground 7 "Successfully disabled debug flag"
            fi
        else
            echo
            gum style --foreground 7 "Operation canceled."
        fi
        sleep 3
        exit
        ;;
    4)
        echo
        echo -e "${Blue}Setting Github Credentials.${NC}"
        ./gitinfo.sh
        sleep 3
        exit
        ;;
    5)
        echo
        echo -e "${Blue}Pushing latest changes upstream.${NC}"
        ./push.sh
        sleep 3
        exit
        ;;
    6)
        echo
        echo -e "${Blue}Resetting Git History.${NC}"
        ./gitclean.sh
        sleep 3
        exit
        ;;
    k)
        echo
        echo -e "${Blue}You opted to build the XeroLinux KDE Flagship ISO.${NC}"
        ./kde.sh
        exit
        ;;
    g)
        echo
        echo -e "${Blue}You opted to build the XeroLinux Gnome Dev Spin.${NC}"
        ./gnome.sh
        exit
        ;;

    c)
        echo
        echo -e "${Blue}You opted to build the XeroLinux Cosmic Alpha Spin.${NC}"
        ./cosmic.sh
        exit
        ;;

    *)
        echo -e "${Yellow}Invalid choice. Please run the script again.${NC}"
        exit 1
        ;;
esac



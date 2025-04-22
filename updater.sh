#!/usr/bin/env bash

# XeroLinux System Updater

set -e

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[1;34m'
BOLD='\033[1m'
MAGENTA='\033[0;35m'
ORANGE='\033[0;33m'
LIGHT_GREEN='\033[1;32m'
RESET='\033[0m'

skipped_updates=false

# Banner function
print_title() {
  clear
  echo -e "${BOLD}${BLUE}"
  if command -v figlet &>/dev/null; then
    figlet -f small "XeroLinux Updater"
  else
    echo "╔════════════════════════════════════════════════════╗"
    echo "║              XeroLinux System Updater             ║"
    echo "╚════════════════════════════════════════════════════╝"
  fi
  echo -e "${RESET}"
}

# Ensure figlet is installed
if ! command -v figlet &>/dev/null; then
  echo -e "${YELLOW}Installing 'figlet' for banner display...${RESET}"
  echo
  if sudo pacman -Syy --noconfirm figlet &>/dev/null; then
    echo -e "${GREEN}[✔] figlet installed.${RESET}\n"
  else
    echo -e "${RED}[✘] Failed to install figlet.${RESET}\n"
  fi
fi

# Show banner
print_title

# Detect AUR helper
if command -v yay &>/dev/null; then
    PKG_MANAGER="yay"
elif command -v paru &>/dev/null; then
    PKG_MANAGER="paru"
else
    PKG_MANAGER="pacman"
fi

# Prompt before system update
read -rp "$(echo -e "${CYAN}🚀 Proceed with full system update? (Y/n): ${RESET}")" confirm_update
if [[ -z "$confirm_update" || "$confirm_update" =~ ^[Yy]$ ]]; then
  echo
  echo -e "${MAGENTA}📦 Updating system packages...${RESET}"
  echo
  if [[ "$PKG_MANAGER" == "pacman" ]]; then
      sudo pacman -Syyu
  else
      $PKG_MANAGER -Syyu
  fi
else
  echo
  echo -e "${ORANGE}⚠️ Skipped system update.${RESET}"
  skipped_updates=true
fi

echo
# Optional Flatpak update
if command -v flatpak &>/dev/null; then
  read -rp "$(echo -e "${CYAN}📦 Flatpak detected. Update Flatpak apps ? (Y/n): ${RESET}")" update_flatpak
  if [[ -z "$update_flatpak" || "$update_flatpak" =~ ^[Yy]$ ]]; then
    echo
    echo -e "${MAGENTA}📦 Updating Flatpak apps...${RESET}"
    echo
    flatpak update -y
  else
    echo
    echo -e "${ORANGE}⚠️ Skipped Flatpak updates.${RESET}"
    skipped_updates=true
  fi
fi

echo
# Optional Rust toolchain update
if command -v rustup &>/dev/null; then
  read -rp "$(echo -e "${CYAN}🦀 Rustup detected. Update ? (Y/n): ${RESET}")" update_rust
  if [[ -z "$update_rust" || "$update_rust" =~ ^[Yy]$ ]]; then
    echo
    echo -e "${MAGENTA}🦀 Updating Rust toolchain...${RESET}"
    echo
    rustup update
  else
    echo
    echo -e "${ORANGE}⚠️ Skipped Rust update.${RESET}"
    skipped_updates=true
  fi
fi

echo
# Firmware update option using fwupd
if command -v fwupdmgr >/dev/null 2>&1; then
  read -rp "$(echo -e "${CYAN}🧩 fwupd detected ! Check & apply device firmware updates? (Y/n): ${RESET}")" confirm_fwupd
  if [[ -z "$confirm_fwupd" || "$confirm_fwupd" =~ ^[Yy]$ ]]; then
    echo
    echo -e "${MAGENTA}🔄 Refreshing firmware metadata...${RESET}"
    echo
    sudo fwupdmgr refresh --force && sudo fwupdmgr update
  else
    echo
    echo -e "${ORANGE}⚠️ Skipped firmware update.${RESET}"
    skipped_updates=true
  fi
fi

echo
if [ "$skipped_updates" = true ]; then
  echo -e "${ORANGE}⚠️ Looks like you skipped some updates. Try not to, for system stability.${RESET}"
else
  echo -e "${LIGHT_GREEN}✅ System update complete. You’re all set!${RESET}"
fi

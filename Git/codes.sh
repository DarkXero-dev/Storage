#!/bin/bash

# === CONFIGURATION ===
SFTP_HOST="172.233.214.202"
SFTP_USER="root"
SFTP_PASS="Oe9%!U6B@84FYfbD"
REMOTE_PATH="/Docker/xeroiso"
LOCAL_TMP="codez.json.tmp"
LOCAL_EDIT="codez.json.edit"

# === COLOR SETUP ===
bold=$(tput bold)
normal=$(tput sgr0)
blue=$(tput setaf 6)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
red=$(tput setaf 1)
reset=$(tput sgr0)

# === FUNCTION: Generate Random Code ===
generate_code() {
    tr -dc 'A-Z0-9' </dev/urandom | head -c8
}

# === FUNCTION: Write Code to JSON ===
write_code_json() {
    local code=$1
    local product=$2
    local email=$3

    if [[ ! -f "$LOCAL_TMP" ]]; then
        echo "{}" > "$LOCAL_TMP"
    fi

    jq --arg code "$code" \
       --arg product "$product" \
       --arg email "$email" \
       '. + {($code): {product: $product, email: $email}}' \
       "$LOCAL_TMP" > "$LOCAL_EDIT"

    mv "$LOCAL_EDIT" "$LOCAL_TMP"
}

# === FUNCTION: Upload to SFTP ===
upload_json() {
    lftp -u "$SFTP_USER","$SFTP_PASS" sftp://"$SFTP_HOST" <<EOF
set xfer:clobber on
cd "$REMOTE_PATH"
put "$LOCAL_TMP" -o codez.json
bye
EOF
}

# === FUNCTION: Download from SFTP ===
download_json() {
    lftp -u "$SFTP_USER","$SFTP_PASS" sftp://"$SFTP_HOST" <<EOF
set xfer:clobber on
cd "$REMOTE_PATH"
get codez.json -o "$LOCAL_TMP"
bye
EOF
    [[ ! -f "$LOCAL_TMP" ]] && echo "{}" > "$LOCAL_TMP"
}

# === UI HEADER ===
clear
echo
echo "${blue}${bold}╔════════════════════════════════════════════════════╗"
echo "║          XeroLinux Code Generator (SFTP)           ║"
echo "╚════════════════════════════════════════════════════╝${reset}"
echo

# === DESKTOP ENV SELECTION ===
echo "${bold}Please choose a product:${normal}"
echo
echo "  1) Plasma"
echo "  2) GNOME"
echo "  3) COSMIC"
echo
read -rp "${yellow}👉 Enter your choice [1-3]: ${reset}" choice
echo

case "$choice" in
    1) PREFIX="KDE"; PRODUCT="kde" ;;
    2) PREFIX="GNOME"; PRODUCT="gnome" ;;
    3) PREFIX="COSMIC"; PRODUCT="cosmic" ;;
    *) echo "${red}❌ Invalid choice. Aborting.${reset}"; exit 1 ;;
esac

# === EMAIL PROMPT ===
read -rp "${bold}📧 Enter email address: ${normal}" EMAIL
echo

# === CODE GEN + SFTP OPS ===
CODE="${PREFIX}-$(generate_code)"

echo "${blue}📡 Downloading current codez.json from SFTP...${reset}"
download_json

echo "${green}🛠️  Adding new code for ${EMAIL}...${reset}"
write_code_json "$CODE" "$PRODUCT" "$EMAIL"

echo "${blue}📤 Uploading updated codez.json to SFTP...${reset}"
upload_json

echo
echo "${green}${bold}✅ Success!${normal} Code generated:"
echo "   📄 ${bold}Code  :${normal} ${CODE}"
echo "   📧 ${bold}Email :${normal} ${EMAIL}"
echo

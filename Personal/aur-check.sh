#!/usr/bin/env bash
# aur_check_standalone.sh - Self-contained curl-pipeable wrapper
# 
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/lenucksi/aur-malware-check/refs/heads/master/aur_check-v2.sh | bash
#   ... does NOT work standalone because it needs package_list.txt
#
# This script fetches both files and runs the check cleanly.
# Safe to pipe directly:
#   curl -fsSL <URL_TO_THIS_FILE> | bash
#   curl -fsSL <URL_TO_THIS_FILE> | bash -s -- --full
#   curl -fsSL <URL_TO_THIS_FILE> | bash -s -- --check-ebpf --check-npm-cache

set -euo pipefail

BASE_URL="https://raw.githubusercontent.com/lenucksi/aur-malware-check/refs/heads/master"
SCRIPT_URL="${BASE_URL}/aur_check-v2.sh"
PKG_LIST_URL="${BASE_URL}/package_list.txt"

# Create isolated temp dir; clean up on exit or interrupt
WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT INT TERM

echo "[*] Fetching aur_check-v2.sh ..."
if ! curl -fsSL "$SCRIPT_URL" -o "$WORKDIR/aur_check-v2.sh"; then
    echo >&2 "[ERROR] Failed to fetch script from: $SCRIPT_URL"
    exit 1
fi

echo "[*] Fetching package_list.txt ..."
if ! curl -fsSL "$PKG_LIST_URL" -o "$WORKDIR/package_list.txt"; then
    echo >&2 "[ERROR] Failed to fetch package list from: $PKG_LIST_URL"
    exit 1
fi

# Sanity check: package list should have at least a few hundred lines
PKG_COUNT=$(grep -c -v '^\s*#' "$WORKDIR/package_list.txt" 2>/dev/null || echo 0)
if [[ "$PKG_COUNT" -lt 100 ]]; then
    echo >&2 "[ERROR] Package list looks too short ($PKG_COUNT entries). Aborting."
    exit 1
fi

echo "[*] Running check against $PKG_COUNT packages ..."
echo

# Pass all args through (e.g. --full, --check-ebpf, etc.)
# Log file is written inside WORKDIR so it doesn't clutter cwd
PACKAGE_LIST_FILE="$WORKDIR/package_list.txt" \
LOG_FILE="$WORKDIR/aur-check.log" \
    bash "$WORKDIR/aur_check-v2.sh" "$@"

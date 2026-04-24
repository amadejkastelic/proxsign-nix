#!/usr/bin/env bash
set -euo pipefail

VERSIONS_URL="https://proxsign.setcce.si/proXSignCustomerPages/getVersions"
LINUX_URL="https://public.setcce.si/proxsign/update/linux/SETCCE_proXSign"
MACOS_URL="https://public.setcce.si/proxsign/update/mac/SETCCE_proXSign"

versions=$(curl -s "$VERSIONS_URL")
latest_linux=$(echo "$versions" | jq -r '.linux')
latest_mac=$(echo "$versions" | jq -r '.mac')

current_linux=$(grep -oP 'version = "\K[^"]+' default.nix)
current_mac=$(grep -oP 'version = "\K[^"]+' darwin.nix)

updated=false

if [ "$current_linux" != "$latest_linux" ]; then
    echo "Linux update available: $current_linux -> $latest_linux"
    url="${LINUX_URL}-${latest_linux}-x86_64.AppImage"
    sha256=$(nix-prefetch-url --type sha256 "$url")
    hash=$(nix hash to-sri --type sha256 "$sha256")
    sed -i "s|version = \".*\";|version = \"${latest_linux}\";|" default.nix
    sed -i "s|hash = \".*\";|hash = \"${hash}\";|" default.nix
    echo "Updated default.nix to version ${latest_linux}"
    updated=true
else
    echo "Linux already up to date: $current_linux"
fi

if [ "$current_mac" != "$latest_mac" ]; then
    echo "macOS update available: $current_mac -> $latest_mac"
    url="${MACOS_URL}_${latest_mac}.pkg"
    sha256=$(nix-prefetch-url --type sha256 "$url")
    hash=$(nix hash to-sri --type sha256 "$sha256")
    sed -i "s|version = \".*\";|version = \"${latest_mac}\";|" darwin.nix
    sed -i "s|hash = \".*\";|hash = \"${hash}\";|" darwin.nix
    echo "Updated darwin.nix to version ${latest_mac}"
    updated=true
else
    echo "macOS already up to date: $current_mac"
fi

if [ "$updated" = false ]; then
    exit 0
fi

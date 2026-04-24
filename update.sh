#!/usr/bin/env bash
set -euo pipefail

VERSIONS_URL="https://proxsign.setcce.si/proXSignCustomerPages/getVersions"
DOWNLOAD_URL="https://public.setcce.si/proxsign/update/linux/SETCCE_proXSign"

current_version=$(grep -oP 'version = "\K[^"]+' default.nix)
latest_version=$(curl -s "$VERSIONS_URL" | nix run nixpkgs#jq -- -r '.linux')

if [ "$current_version" = "$latest_version" ]; then
    echo "Already up to date: $current_version"
    exit 0
fi

echo "Update available: $current_version -> $latest_version"

url="${DOWNLOAD_URL}-${latest_version}-x86_64.AppImage"
sha256=$(nix-prefetch-url --type sha256 "$url")
hash=$(nix hash to-sri --type sha256 "$sha256")

sed -i "s|version = \".*\";|version = \"${latest_version}\";|" default.nix
sed -i "s|hash = \".*\";|hash = \"${hash}\";|" default.nix

echo "Updated default.nix to version ${latest_version}"

#!/bin/sh
#
# This is a Shell script for xray based alpine with Docker image
#
VERSION=$1
TARGETPLATFORM=$2
XRAY_REPO="https://github.com/XTLS/Xray-core"
X_ARCH=

echo "TARGETPLATFORM=$TARGETPLATFORM"

case "$TARGETPLATFORM" in
'linux/386')
  X_ARCH="32"
  ;;
'linux/amd64')
  X_ARCH="64"
  ;;
'linux/arm/v6')
  X_ARCH="arm32-v6"
  ;;
'linux/arm/v7')
  X_ARCH="arm32-v7a"
  ;;
'linux/arm64/v8' | 'linux/arm64')
  X_ARCH="arm64-v8a"
  ;;
'linux/ppc64le')
  X_ARCH="ppc64le"
  ;;
'linux/s390x')
  X_ARCH="s390x"
  ;;
esac

[ -z "$X_ARCH" ] && echo "Error: Not supported OS Architecture" && exit 1
# Download release file
XRAY_ZIP_FILE="Xray-linux-$X_ARCH.zip"

echo "Downloading release file: $XRAY_ZIP_FILE from $XRAY_REPO/releases/download/v$VERSION/$XRAY_ZIP_FILE"
if ! wget -O /xray.zip "$XRAY_REPO/releases/download/v$VERSION/$XRAY_ZIP_FILE" >/dev/null 2>&1; then
  echo "Error: Failed to download release file: $XRAY_ZIP_FILE" && exit 1
fi
echo "Download release file: $XRAY_ZIP_FILE completed"

# Unzip XRAY_ZIP_FILE
cd /
unzip /xray.zip
chmod +x /xray

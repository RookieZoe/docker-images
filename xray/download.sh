#!/bin/sh
#
# This is a Shell script for xray based alpine with Docker image
#
VERSION=$1
PLATFORM=$2
if [ -z "$PLATFORM" ]; then
    ARCH="64"
else
    case "$PLATFORM" in
        linux/386)
            ARCH="32"
            ;;
        linux/amd64)
            ARCH="64"
            ;;
        linux/arm/v6)
            ARCH="arm32-v6"
            ;;
        linux/arm/v7)
            ARCH="arm32-v7a"
            ;;
        linux/arm64|linux/arm64/v8)
            ARCH="arm64-v8a"
            ;;
        linux/ppc64le)
            ARCH="ppc64le"
            ;;
        linux/s390x)
            ARCH="s390x"
            ;;
        *)
            ARCH=""
            ;;
    esac
fi

[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1
# Download release file
XRAY_ZIP_FILE="Xray-linux-${ARCH}.zip"

echo "Downloading release file: ${XRAY_ZIP_FILE} from https://github.com/XTLS/Xray-core/releases/download/v${VERSION}/${XRAY_ZIP_FILE}"
wget -O /xray.zip "https://github.com/XTLS/Xray-core/releases/download/v${VERSION}/${XRAY_ZIP_FILE}" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to download release file: ${XRAY_ZIP_FILE}" && exit 1
fi
echo "Download release file: ${XRAY_ZIP_FILE} completed"

# Unzip XRAY_ZIP_FILE
cd /
unzip /xray.zip

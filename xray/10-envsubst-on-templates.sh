#!/bin/sh

set -e

ME=$(basename "$0")

auto_envsubst() {
  ESUB_SUFFIX="${XRAY_ENVSUBST_TEMPLATE_SUFFIX:-.tpl}"
  ESUB_OUTPUT_DIR="${XRAY_ENVSUBST_OUTPUT_DIR:-/etc/xray}"
  ESUB_TEMPLATE_DIR="${XRAY_ENVSUBST_TEMPLATE_DIR:-/etc/xray/tpls}"
  ESUB_SUBDIR=
  ESUB_TEMPLATE=
  ESUB_OUTPUT_PATH=
  ESUB_RELATIVE_PATH=

  # shellcheck disable=SC2046
  ESUB_DEFINED_ENVS=$(printf "\${%s} " $(env | cut -d= -f1))

  [ -d "$ESUB_TEMPLATE_DIR" ] || return 0

  if [ ! -w "$ESUB_OUTPUT_DIR" ]; then
    echo >&3 "$ME: ERROR: $ESUB_TEMPLATE_DIR exists, but $ESUB_OUTPUT_DIR is not writable"
    return 0
  fi

  find "$ESUB_TEMPLATE_DIR" -follow -type f -name "*$ESUB_SUFFIX" -print | while read -r ESUB_TEMPLATE; do
    ESUB_RELATIVE_PATH="${ESUB_TEMPLATE#$ESUB_TEMPLATE_DIR/}"
    ESUB_OUTPUT_PATH="$ESUB_OUTPUT_DIR/${ESUB_RELATIVE_PATH%$ESUB_SUFFIX}"
    ESUB_SUBDIR=$(dirname "$ESUB_RELATIVE_PATH")
    # create a subdirectory where the template file exists
    mkdir -p "$ESUB_OUTPUT_DIR/$ESUB_SUBDIR"
    echo >&3 "$ME: Running envsubst on $ESUB_TEMPLATE to $ESUB_OUTPUT_PATH"
    envsubst "$ESUB_DEFINED_ENVS" <"$ESUB_TEMPLATE" >"$ESUB_OUTPUT_PATH"
  done
}

auto_envsubst

exit 0

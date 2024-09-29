#!/usr/bin/env sh
set -o errexit

WAYVNC_ENABLE_AUTH="${WAYVNC_ENABLE_AUTH:-false}"
WAYVNC_USERNAME="${WAYVNC_USERNAME:-wayvnc}"
WAYVNC_PASSWORD="${WAYVNC_PASSWORD:-wayvnc}"

sed ~/.config/wayvnc/config -i -e "s/\$WAYVNC_ENABLE_AUTH/$WAYVNC_ENABLE_AUTH/g"
sed ~/.config/wayvnc/config -i -e "s/\$WAYVNC_USERNAME/$WAYVNC_USERNAME/g"
sed ~/.config/wayvnc/config -i -e "s/\$WAYVNC_PASSWORD/$WAYVNC_PASSWORD/g"

case "$1" in
    sh|bash)
        set -- "$@"
    ;;
    *)
        set -- sway
    ;;
esac

exec "$@"

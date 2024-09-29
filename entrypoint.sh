#!/usr/bin/env sh
set -o errexit

export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
export WLR_BACKENDS="${WLR_BACKENDS:-headless}"
export WLR_LIBINPUT_NO_DEVICES="${WLR_LIBINPUT_NO_DEVICES:-1}"
SWAY_RESOLUTION="${SWAY_RESOLUTION:-1920x1080}"
WAYVNC_PORT="${WAYVNC_PORT:-5910}"
WAYVNC_ENABLE_AUTH="${WAYVNC_ENABLE_AUTH:-false}"
WAYVNC_USERNAME="${WAYVNC_USERNAME:-wayvnc}"
WAYVNC_PASSWORD="${WAYVNC_PASSWORD:-wayvnc}"
WAYVNC_RSA_KEY="${WAYVNC_RSA_KEY:-"/certs/rsa_key.pem"}"
WAYVNC_KEY="${WAYVNC_KEY:-"/certs/key.pem"}"
WAYVNC_CERT="${WAYVNC_CERT:-"/certs/cert.pem"}"

sed ~/.config/sway/config -i -e "s/\$SWAY_RESOLUTION/$SWAY_RESOLUTION/g"
sed ~/.config/wayvnc/config -i -e "s/\$WAYVNC_PORT/$WAYVNC_PORT/g"
sed ~/.config/wayvnc/config -i -e "s/\$WAYVNC_ENABLE_AUTH/$WAYVNC_ENABLE_AUTH/g"
sed ~/.config/wayvnc/config -i -e "s/\$WAYVNC_USERNAME/$WAYVNC_USERNAME/g"
sed ~/.config/wayvnc/config -i -e "s/\$WAYVNC_PASSWORD/$WAYVNC_PASSWORD/g"
sed ~/.config/wayvnc/config -i -e "s|\$WAYVNC_RSA_KEY|$WAYVNC_RSA_KEY|g"
sed ~/.config/wayvnc/config -i -e "s|\$WAYVNC_KEY|$WAYVNC_KEY|g"
sed ~/.config/wayvnc/config -i -e "s|\$WAYVNC_CERT|$WAYVNC_CERT|g"

# generate SSL certificate if it doesn't exist
if [ ! -f "$WAYVNC_RSA_KEY" ] || [ ! -f "$WAYVNC_KEY" ] || [ ! -f "$WAYVNC_CERT" ]; then
    echo "Generating wayvnc RSA key..."
    ssh-keygen -m pem -f "$WAYVNC_RSA_KEY" -t rsa -N ""
    echo "Generating wayvnc SSL certificate..."
    openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
        -keyout "$WAYVNC_KEY" -out "$WAYVNC_CERT" -subj /CN=localhost \
        -addext subjectAltName=DNS:localhost,DNS:localhost,IP:127.0.0.1
fi

case "$1" in
    sh|bash)
        set -- "$@"
    ;;
    *)
        set -- sway
    ;;
esac

exec "$@"

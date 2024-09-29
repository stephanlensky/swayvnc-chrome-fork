FROM debian:bookworm

ENV USER="chrome-user"

USER root

RUN useradd -ms /bin/bash $USER

# replace with the group/gid which owns the /dev/dri/renderD128 device on host
RUN addgroup --system render --gid 107 && adduser $USER render

# Install sway, xwayland, wayvnc, google-chrome-stable
RUN apt-get update && apt-get install -y wget gnupg2
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get install -y sway xwayland wayvnc google-chrome-stable

# Copy sway/wayvnc configs
COPY sway/config /etc/sway/config
COPY sway/config.d/exec /etc/sway/config.d/exec
COPY wayvnc/config /home/$USER/.config/wayvnc/config
RUN chown -R $USER:$USER /home/$USER/.config

USER $USER

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

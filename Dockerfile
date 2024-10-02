FROM archlinux:latest
LABEL org.opencontainers.image.source="https://github.com/stephanlensky/swayvnc-chrome"

ARG USER=chrome-user
ARG PUID=1000
ARG PGID=1000
ARG DEVICE_ACCESS_GID=107

ENV USER=$USER
ENV PUID=$PUID
ENV PGID=$PGID
ENV DEVICE_ACCESS_GID=$DEVICE_ACCESS_GID

USER root

RUN groupadd -g $PGID $USER && \
    groupadd -g $DEVICE_ACCESS_GID gpu_access && \
    useradd -ms /bin/bash $USER -u $PUID -g $PGID -G gpu_access

# Install sway, xorg-xwayland, wayvnc, openssh (required to generate wayvnc RSA key), and chromium
RUN pacman -Syyu --noconfirm sway xorg-xwayland wayvnc openssh chromium

# Copy sway/wayvnc configs
COPY --chown=$USER:$USER sway/config /home/$USER/.config/sway/config
COPY --chown=$USER:$USER wayvnc/config /home/$USER/.config/wayvnc/config

# Make directory for wayvnc certs
RUN mkdir /certs
RUN chown -R $USER:$USER /certs

USER $USER

COPY entrypoint.sh /
WORKDIR /home/$USER
ENTRYPOINT ["/entrypoint.sh"]

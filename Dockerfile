FROM debian:sid-slim
LABEL org.opencontainers.image.source="https://github.com/stephanlensky/swayvnc-chrome"

ARG USER=chrome-user
ARG PUID=1000
ARG PGID=1000
ARG RENDER_GROUP_GID=107

ENV DOCKER_USER=$USER
ENV PUID=$PUID
ENV PGID=$PGID

USER root
RUN groupadd -g $PGID $USER
RUN groupadd -g $RENDER_GROUP_GID docker-render
RUN useradd -ms /bin/bash -u $PUID -g $PGID $USER
RUN usermod -aG docker-render $USER

# Install Chromium and dependencies for running under wayland with VNC support
RUN apt-get update && apt-get install -y --no-install-recommends \
    sway xwayland wayvnc openssh-client openssl chromium \
    && rm -rf /var/lib/apt/lists/*

# Copy sway/wayvnc configs
COPY --chown=$USER:$USER sway/config /home/$USER/.config/sway/config
COPY --chown=$USER:$USER wayvnc/config /home/$USER/.config/wayvnc/config

# Make directory for wayvnc certs
RUN mkdir /certs
RUN chown -R $USER:$USER /certs

# Copy and set the entrypoint script
COPY --chown=$USER:$USER entrypoint.sh /
COPY --chown=$USER:$USER entrypoint_user.sh /
ENTRYPOINT ["/entrypoint.sh"]

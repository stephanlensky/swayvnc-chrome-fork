#!/usr/bin/env bash
set -e

old_uid=$(id -u "$DOCKER_USER")
old_gid=$(id -g "$DOCKER_USER")

# set new uid for the non-root user and take ownership of files
echo "Setting new UID $PUID for user $DOCKER_USER"
usermod -u "$PUID" "$DOCKER_USER"
set +e
chown -Rhc "$PUID" /certs
chown -Rhc --from="$old_uid" "$PUID" /
set -e

# set new gid for the non-root user and take ownership of files
echo "Setting new GID $PGID for user $DOCKER_USER"
groupmod -g "$PGID" "$DOCKER_USER"
set +e
chown -Rhc ":$PGID" /certs
chown -Rhc --from=":$old_gid" ":$PGID" /
set -e

# set new gid for the render group if provided
if [ -n "$RENDER_GROUP_GID" ]; then
    echo "Setting new GID $RENDER_GROUP_GID for group docker-render"
    groupmod -g "$RENDER_GROUP_GID" docker-render
fi

# call main entrypoint as non-root user
exec su "$DOCKER_USER" -c "/entrypoint_user.sh $*"

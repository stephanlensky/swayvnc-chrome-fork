#!/usr/bin/env bash
set -e

old_uid=$(id -u "$DOCKER_USER")
old_gid=$(id -g "$DOCKER_USER")

# get new uid/gid for the non-root user according to environment variables
PUID=${PUID:-$old_uid}
PGID=${PGID:-$old_gid}

# set new uid for the non-root user and take ownership of files
usermod -u "$PUID" "$DOCKER_USER" > /dev/null 2>&1
set +e
chown -Rhc "$PUID" /certs > /dev/null 2>&1
chown -Rhc --from="$old_uid" "$PUID" / > /dev/null 2>&1
set -e

# set new gid for the non-root user and take ownership of files
groupmod -g "$PGID" "$DOCKER_USER" > /dev/null 2>&1
set +e
chown -Rhc ":$PGID" /certs > /dev/null 2>&1
chown -Rhc --from=":$old_gid" ":$PGID" / > /dev/null 2>&1
set -e

# set new gid for the render group if provided
if [ -n "$RENDER_GROUP_GID" ]; then
    groupmod -g "$RENDER_GROUP_GID" docker-render
fi

# call main entrypoint as non-root user
exec su "$DOCKER_USER" -c "/entrypoint_user.sh $*"

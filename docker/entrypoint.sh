#!/bin/sh
set -e

# Source the shell profile
. /etc/profile

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

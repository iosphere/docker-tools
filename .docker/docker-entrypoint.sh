#!/bin/bash

# Show versions
# echo "tools:"
# docker --version
# docker-machine --version
# docker-compose --version
# echo ""

if [ -z ${MACHINE_NAME+x} ]
then
    echo -n ""
else
    # Configure Docker endpoint
    echo "setting up environment for '$MACHINE_NAME':"
    eval $(docker-machine env --shell bash $MACHINE_NAME)

    # fix ssh key permissions
    chown 600 "/root/.docker/machine/machines/${MACHINE_NAME}/id_rsa"

    # Show info
    docker info
fi

# Execute CMD
exec "$@"


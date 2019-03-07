#!/bin/bash
set -e

dr_docker_image=docker-runner
dr_confd=/opt/docker-runner
dr_mount_point=/data
dr="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "${dr_confd}:${dr_mount_point}" $dr_docker_image"
#dr=/opt/docker-runner/docker-runner

set -- $SSH_ORIGINAL_COMMAND

pool_name=$1
run_command=${@:2}

# Pool name exists
if [ -f "${dr_confd}/${pool_name}.json" ]; then

    echo
    echo "=== Docker runner ==="
    echo "Executing command:"
    echo "Containers pool: $pool_name"
    echo "Command $run_command"
    echo "====================="
    echo

    exec ${dr} -c "${dr_mount_point}/${pool_name}.json" ${run_command}
else
    echo
    if [ -z $pool_name ];then
        echo "ERROR: pool name not provided"
    else
        echo "ERROR: invalid pool name: $pool_name doesn't exist"
    fi
    cat << EOF

Usage: <pool_name> [command]

Available commands:
    ls                              List all the available containers of the pool <pool_name>
    run [--id <container_id]        Run a contaier from the pool <pool_name> if --id <container_id> is not spcified the first available container will be spawn
    kill --id <container_id>        Terminate a running container specified by <container_id>
EOF

    echo
    echo "Available pools:"
    find "${dr_confd}" -name "*json" -exec basename {} \; | sed -e 's/.json//g'
    exit -1
fi

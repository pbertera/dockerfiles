#!/bin/bash
set -e

dr_docker_image=docker-runner

dr_confd=/opt/docker-runner
dr="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v ${dr_confd}:/data/ $dr_docker_image"
#dr=/opt/docker-runner/docker-runner

set -- $SSH_ORIGINAL_COMMAND

pool_name=$1
run_command=${@:2}

echo
echo "=== Docker runner ==="
echo "Executing command:"
echo "Containers pool: $pool_name"
echo "Command $run_command"
echo "====================="
echo 

exec ${dr} -c /data/${pool_name}.json ${run_command}

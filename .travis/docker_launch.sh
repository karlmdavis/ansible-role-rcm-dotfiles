#!/bin/bash

# Bail on the first error.
set -e

# Echo all commands before running them.
set -v

# Build and start the container, running systemd and ssh.
docker build -t ansible_test_rcm/${PLATFORM} ./.travis/docker_platforms/${PLATFORM}
docker run \
	--cap-add=SYS_ADMIN \
	--detach \
	-p 127.0.0.1:13022:22 \
	--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
	--tmpfs /run \
	--tmpfs /run/lock \
	--name ansible_test_rcm.${PLATFORM} \
	ansible_test_rcm/${PLATFORM}


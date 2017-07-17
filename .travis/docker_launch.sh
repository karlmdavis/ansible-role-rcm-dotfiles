#!/bin/bash

# Bail on the first error.
set -e

# Echo all commands before running them.
set -v

# Build and start the CentOS 7 container, running systemd.
docker build -t ansible_test_rcm/${TEST_CASE} ./.travis/${TEST_CASE}
docker run \
	--cap-add=SYS_ADMIN \
	--detach \
	-p 127.0.0.1:13022:22 \
	--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
	--tmpfs /run \
	--tmpfs /run/lock \
	ansible_test_rcm/${TEST_CASE}


#!/bin/bash

# Stop immediately if any command returns a non-zero result.
set -e
set -x

# Determine the directory that this script is in.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Run everything from that directory.
cd "${SCRIPT_DIR}"

# Determine which inventory to use, based on TARGET.
if [[ "${TARGET}" == "localhost" ]]; then
  INVENTORY='inventory_localhost'
elif [[ "${TARGET}" == "docker" ]]; then
  INVENTORY='inventory_docker'
else
  >&2 echo "Unsupported TARGET of '${TARGET}'."; exit 1
fi

# Basic role syntax check
pipenv run ansible-playbook test_basic.yml "--inventory=${INVENTORY}" --syntax-check

# Run the Ansible test case.
pipenv run ansible-playbook test_basic.yml "--inventory=${INVENTORY}"

# Run the role/playbook again, checking to make sure it's idempotent.
# FIXME: This role isn't idempotent, due to always running `rcup`.
pipenv run ansible-playbook $TEST_PLAY "--inventory=${INVENTORY}" \
  | tee /dev/tty \
  | grep -q 'changed=0.*failed=0' \
  && (echo 'Idempotence test: pass' && exit 0) \
  || (echo 'Idempotence test: fail' && exit 1)

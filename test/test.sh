#!/bin/bash

# Stop immediately if any command returns a non-zero result.
set -e

# Determine the directory that this script is in.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Run everything from that directory.
cd "${SCRIPT_DIR}"

# Activate the Python virtual env.
source venv/bin/activate

# Determine which inventory to use, based on TARGET.
if [[ "${TARGET}" -eq "localhost" ]]; then
  INVENTORY='inventory_localhost'
elif [[ "${TARGET}" -eq "docker" ]]; then
  INVENTORY='inventory_docker'
else
  >&2 echo "Unsupported TARGET of '${TARGET}'."; exit 1
fi

# Basic role syntax check
ansible-playbook test_basic.yml "--inventory=${INVENTORY}" --syntax-check

# Run the Ansible test case.
ansible-playbook test_basic.yml "--inventory=${INVENTORY}"

# Run the role/playbook again, checking to make sure it's idempotent.
# FIXME: This role isn't idempotent, due to always running `rcup`.
#ansible-playbook $TEST_PLAY "--inventory=${INVENTORY}" \
#  | tee /dev/tty \
#  | grep -q 'changed=0.*failed=0' \
#  && (echo 'Idempotence test: pass' && exit 0) \
#  || (echo 'Idempotence test: fail' && exit 1)

#!/bin/bash

# Bail on the first error.
set -e

# Echo all commands before running them.
set -v

# Start the CentOS 7 container, running systemd.
sudo docker run --detach --privileged --volume="${PWD}":/var/travis_test_source:ro --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro centos:7 /usr/lib/systemd/systemd > /tmp/container_id

sudo docker exec "$(cat /tmp/container_id)" ls -la /var/travis_test_source

# In order to test our Ansible role against this container, we need to either: 
# 1) install Ansible on the host, configure SSH on the container and then 
# run the role from the host against the container, or 2) install Ansible on
# the container and run things from there against "localhost". Option 2 is 
# easier, so that's what we're doing.

# Install Python and Ansible inside the container.
sudo docker exec "$(cat /tmp/container_id)" mkdir /var/travis_test_work
sudo docker exec "$(cat /tmp/container_id)" yum -y install epel-release
sudo docker exec "$(cat /tmp/container_id)" yum -y install python-virtualenv libffi-devel
sudo docker exec "$(cat /tmp/container_id)" yum groupinstall -y development
sudo docker exec "$(cat /tmp/container_id)" virtualenv -p /usr/bin/python2.7 /var/travis_test_work/venv
sudo docker exec "$(cat /tmp/container_id)" /var/travis_test_work/venv/bin/pip install -r /var/travis_test_source/requirements.txt 

# Run the Ansible role in and against the container.
sudo docker exec "$(cat /tmp/container_id)" /var/travis_test_work/venv/bin/ansible-playbook /var/travis_test_source/.travis/test.yml --inventory-file=/var/travis_test_source/.travis/inventory


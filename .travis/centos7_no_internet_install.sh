#!/bin/bash

# May be needed to work around problem with CentOS7 on Travis CI's Ubuntu 14.04: https://github.com/moby/moby/issues/6980
#echo 'DOCKER_OPTS="-H tcp://127.0.0.1:2375 -H unix:///var/run/docker.sock -s devicemapper"' | sudo tee /etc/default/docker > /dev/null
#sudo service docker restart
#sleep 5

docker pull centos:7


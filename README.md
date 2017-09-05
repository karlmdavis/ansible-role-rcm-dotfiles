Ansible Role for RCM
====================

This Ansible role can be used to install and configure [RCM](https://github.com/thoughtbot/rcm), a management suite for dotfiles.

## Requirements

This role requires the following on the Ansible management system:

* git>=1.7.1 (the command line tool)

The system(s) being managed require the following:

* Ubuntu 16.04 (unless `rcm_install_mode: no_internet` is used, in which case most any OS should be supported)

## Role Variables

Here are the variables that must be defined by users:

```
rcm_user: user42
rcm_repos:
  - repo: 'git@github.com:foosball/repo.git'
    dest: '/home/user42/.dotfiles-repo.git'
  - repo: 'https://foosball.example.com/path/to/repo2.git'
    refspec: '+refs/pull/*:refs/heads/*'
    dest: '/home/user42/.dotfiles-repo2.git'
```

In addition, if the `rcm_install_mode` variable is set to `no_internet`, the role will perform all downloads on the Ansible management system, rather than assuming that the system being managed has an internet connection. In this mode, RCM will be installed per-user, rather than system-wide.

See [defaults/main.yml](./defaults/main.yml) for the list of defaulted variables and their default values.

## Dependencies

This role does not have any runtime dependencies on other Ansible roles.

## Example Playbook

Here's an example of how to apply this role to the `box` host in an Ansible play:

```
- hosts: box
  tasks:
    - name: Install and Configure RCM
      include_role:
        name: karlmdavis.rcm
      vars:
        rcm_user: ansible_test
        rcm_install_mode: no_internet
        rcm_repos:
          - repo: 'https://foosball.example.com/path/to/repo.git'
            dest: '/home/karl/.dotfiles-repo.git'
```

## Development Environment

In order to develop/modify this project, a number of tools need to be installed.

### Python

This project requires Python 2.7. It can be installed as follows:

    $ sudo apt-get install python

### virtualenv

This project has some dependencies that have to be installed via `pip` (as opposed to `apt-get`). Accordingly, it's strongly recommended that you make use of a [Python virtual environment](http://docs.python-guide.org/en/latest/dev/virtualenvs/) to manage those dependencies.

If it isn't already installed, install the `virtualenv` package. On Ubuntu, this is best done via:

    $ sudo apt-get install python-virtualenv

Next, create a virtual environment for this project and install the project's dependencies into it:

    $ cd rcm-ansible-role.git
    $ virtualenv -p /usr/bin/python2.7 venv
    $ source venv/bin/activate
    $ pip install -r requirements.txt

The `source` command above will need to be run every time you open a new terminal to work on this project.

Be sure to update the `requirements.frozen.txt` file after `pip install`ing a new dependency for this project:

    $ pip freeze > requirements.frozen.txt

### Docker

It can often be useful to launch the test Docker containers locally. To do so, one must have Docker installed. The following commands can then be used:

```
# Launch the Docker container for a particular test case (as used in `.travis.yml`).
$ PLATFORM=ubuntu_16_04 sudo -E .travis/docker_launch.sh

# List all of the running containers.
$ sudo docker ps -a

# Given a container ID, e.g. `abc123`, run Bash in that container.
$ PLATFORM=ubuntu_16_04 sudo docker exec ansible_test_rcm.${PLATFORM} /bin/bash

# Alternatively, connect to SSH in that container. The password for these containers is "secret".
$ ssh-keygen -f ~/.ssh/known_hosts -R [localhost]:13022
$ ssh ansible_test@localhost -p 13022

# The Ansible test scripts used by Travis can be run manually:
$ source venv/bin/activate
$ mkdir .travis/roles && ln -s `pwd` .travis/roles/karlmdavis.rcm
$ cd .travis/
$ TEST_CASE=default ansible-playbook test_base.yml --inventory-file=inventory
$ rm roles/karlmdavis.rcm && rmdir roles/

# Stop all running containers. See <https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes> for instructions on how to remove their images, etc. to reclaim disk space.
$ sudo docker stop $(sudo docker ps -a -q)
```

## License

This project is licensed under the [GNU General Public License, Version 3](./LICENSE).


[![Build Status](https://travis-ci.org/karlmdavis/ansible-role-rcm-dotfiles.svg?branch=master)](https://travis-ci.org/karlmdavis/ansible-role-rcm-dotfiles)

Ansible Role for RCM
====================

This Ansible role can be used to install and configure [RCM](https://github.com/thoughtbot/rcm), a management suite for dotfiles.

## Requirements

This role requires the following on the Ansible management system:

* Ansible>=2.4.0.0
* git>=1.7.1 (the command line tool)

The system(s) being managed require the following:

* Ubuntu 16.04 (unless `rcm_install_mode: no_internet` is used, in which case most any OS should be supported)

## Role Variables

Here are the variables that can be defined by users:

* `rcm_user`: The user that the RCM repos will be installed for.
* `rcm_repos` The list of Git repositories whose dotfiles will be installed.
    * `repo`: The Git repo URL.
    * `refspec`: The specific Git revision to clone, defaults to `master`.
    * `dest`: The directory to clone the repo to.
* `rcm_install_mode`: If set to `no_internet`, the role will perform all downloads on the Ansible management system, rather than assuming that the system being managed has an internet connection. In this mode, RCM will be installed per-user, rather than system-wide.
* `rcm_replace_existing_files`: If set to `true`, the `-f` flag will be passed to `rcup`, allowing it to override existing files. This can be used, for example, to replace the user's default `bashrc` file with one from your dotfiles repo.

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
        name: karlmdavis.rcm-dotfiles
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

### Docker

It can often be useful to launch the test Docker containers locally. To do so, one must have Docker installed. Installing that is outside the scope of this guide, but a quick web search should get you started with this.

### Running the Tests

Once those tools are installed, the [`test/run-tests.sh`](./test/run-tests.sh) script can be used to run the tests locally. Alternatively, changes can be pushed to a GitHub branch or pull request, and Travis CI will run the tests for you: [Travis CI: karlmdavis/ansible-role-rcm-dotfiles](https://travis-ci.org/karlmdavis/ansible-role-rcm-dotfiles).

## License

This project is licensed under the [GNU General Public License, Version 3](./LICENSE).


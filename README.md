Ansible Role for RCM
====================

This Ansible role can be used to install and configure [RCM](https://github.com/thoughtbot/rcm), a management suite for dotfiles.

Requirements
------------

Depending on how it's run, this role requires the following on either the Ansible management system or on the system being managed:

* git>=1.7.1 (the command line tool)

Role Variables
--------------

Here are the variables that must be defined by users:

    rcm_user: user42
    rcm_repos:
      - repo: 'https://foosball.example.org/path/to/repo.git'
      - repo: 'https://foosball.example.org/path/to/repo2.git'
        refspec: '+refs/pull/*:refs/heads/*'
        dest: '/home/user42/superawesome'

In addition, if the `rcm_role` variable is set to `no_internet`, the role will perform all downloads on the Ansible management system, rather than assuming that the system being managed has an internet connection. In this mode, RCM will be installed per-user, rather than system-wide.

See [defaults/main.yml](./defaults/main.yml) for the list of defaulted variables and their default values.

Dependencies
------------

This role does not have any runtime dependencies on other Ansible roles.

Example Playbook
----------------

Here's an example of how to apply this role to the `box` host in an Ansible play:

    - hosts: box
      roles:
        - role: karlmdavis.rcm
          rcm_user: user42
          rcm_repos:
            - repo: 'https://foosball.example.org/path/to/repo.git'

## License

This project is licensed under the [GNU General Public License, Version 3](./LICENSE).


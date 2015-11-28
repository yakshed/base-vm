InnoHub Ansible : ruby-install [![Build Status](https://travis-ci.org/innohub-ansible/ruby-install.svg?branch=master)](https://travis-ci.org/innohub-ansible/ruby-install)
==========================================================================================================================================================================

Installs ruby-install.

Requirements
------------

Tested ONLY on Ubuntu 14.04 Trusty.

Role Variables
--------------

ruby_install_version : defaults to '0.5.0'

Dependencies
------------

None

Example Playbook
----------------

Example Playbook:

    - hosts: servers
      roles:
         - { role: innohub-ansible.ruby-install }

Example Role:

    dependencies:
      - { role: ruby_install }

License
-------

MIT

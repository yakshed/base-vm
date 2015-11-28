# InnoHub Ansible : ruby [![Build Status](https://travis-ci.org/innohub-ansible/ruby.svg?branch=master)](https://travis-ci.org/innohub-ansible/ruby)

Uses ruby-install and chruby to install and setup ruby.

Role Variables
--------------

ruby_install_ruby_versions : Required : Array of ruby versions to install

    ruby_install_ruby_versions:
      - 1.9.3
      - 2.1.2

ruby_default_version : Required : The default ruby version for chruby to use

    ruby_default_version: 2.1.2

ruby_users : Required : Array of system users to set default .gemrc and .ruby-version

    ruby_users
      - root
      - ubuntu
      - deploy

Dependencies
------------

* innohub-ansible.ruby-install
* innohub-ansible.chruby

Example Playbook
----------------

Playbook:

    - hosts: servers
      roles:
         - { role: innohub-ansible.ruby }

Role:

    dependencies:
      - { role: innohub-ansible.ruby }

License
-------

MIT

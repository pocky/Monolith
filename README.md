Monolith
===

Monolith is a simple Vagrant/Ansible bootstrap for create a new project.

Monolith is shipped with:

- Debian 8.2
- Git
- Composer
- Mariadb
- Nginx
- NodeJS
- PHP
- Postfix

And an user role for add your local ssh key to your production.

Setup
===

Install Ansible and Vagrant. Then go to Vagrantfile and change vars:

```ruby
options = {
  :name             => 'monolith',
  :domain_tld       => 'project'
}
```

Then run `vagrant up`.

After build, feel free to handle your project as your choice. My choice is to 
add a new role to ansible (named by my app) for deploying (like in a prod environment) my project.

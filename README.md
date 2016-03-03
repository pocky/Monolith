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

Local config
===

If you want to add your local .gitconfig or composer.auth, you should create a `Vagrantfile` in 
`~.vagrant.d/` and add this:

```
Vagrant.configure("2") do |config|

    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :machine

      config.cache.synced_folder_opts = {
        type: :nfs,
        mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
      }

      config.cache.enable :generic
    end

    # Git
    if File.exists?(File.join(Dir.home, '.gitconfig')) then
      config.vm.provision :file do |file|
        file.source      = '~/.gitconfig'
        file.destination = '/home/vagrant/.gitconfig'
      end
    end

    # Composer
    if File.exists?(File.join(Dir.home, '.composer/auth.json')) then
      config.vm.provision :file do |file|
        file.source      = '~/.composer/auth.json'
        file.destination = '/home/vagrant/.composer/auth.json'
      end
    end

end
```

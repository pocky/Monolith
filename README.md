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
- PHP 7.0.*
- Postfix

And an user role for add your local ssh key to your production server.

Setup
===

Install Virtualbox (or VMware), Ansible, Vagrant and landrush. Then open `Vagrantfile` and update theses lines :

- 16: your favorite local domain tld,
- 67: name of your VM (ea your project)
- 70: hostname
- 71: domain
- 73: the folder name of your project (from git clone for example). If you don't have any project, remove this line.

Then run `vagrant up`.

After build, feel free to handle your project as your choice. My choice is to 
add a new role to ansible (named by my app) for deploying (like in a prod environment) my project.

If you want to have multiple VM, just copy line 66 to 114 and rename "front" to "back" for example. It works fine.

Local config
===

If you want to add your local .gitconfig or composer.auth, you should create a `Vagrantfile` in 
`~.vagrant.d/` and add this:

```
Vagrant.configure("2") do |config|

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

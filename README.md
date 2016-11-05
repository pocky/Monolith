Monolith
===

Monolith ([pronunciation](https://dictionary.cambridge.org/pronunciation/english/monolith)) 
is a simple Vagrant/Ansible bootstrap for create a new virtual machine for web application developers.

Monolith is shipped with:

- Debian 8.6
- Git
- Composer
- Mariadb
- NGINX
- Node.js 7.0
- PHP 7.0
- Postfix

And an SSH role for add your local ssh key to your production server.

Setup
===

Install theses packages:
- [Virtualbox](https://www.virtualbox.org/), 
- [Ansible](https://www.ansible.com/), 
- [Vagrant](https://www.vagrantup.com/)
- [landrush](https://github.com/vagrant-landrush/landrush),
- [cachier](https://github.com/fgrehm/vagrant-cachier) (optional).

Then open `Vagrantfile` and update theses lines :
- 16: your favorite local domain tld,
- 61: name of your VM (ea your project)
- 64: hostname
- 65: domain
- 67: the folder name of your project (from git clone for example). If you don't have any project, remove this line.

Or if you love make, just edit `Makefile` vars.
Then run `make init` if you don't like Makefiles.

After build, feel free to handle your project as your choice. My choice is to 
add a new role to Ansible (named by my app) for deploying (like in a prod environment) my project.

If you want to have multiple VM, just copy line 66 to 114 and rename "app" to "front" 
and add another "back" for example. It works fine.

Local config
===

If you want to add your local .gitconfig or composer.auth, you should create a `Vagrantfile` in 
`~/.vagrant.d/` and add this:

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

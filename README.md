# Monolith

Monolith ([pronunciation](https://dictionary.cambridge.org/pronunciation/english/monolith))
is a simple Vagrant/Ansible bootstrap for create a new virtual machine for web application developers.

Monolith is shipped with:

- Debian 9.1 (Stretch)
- Git

And an SSH role for add your local ssh key to your production server.

## Setup

Install theses packages:
- [Virtualbox](https://www.virtualbox.org/) - v5.1.26,
- [Ansible](https://www.ansible.com/) - v2.3,
- [Vagrant](https://www.vagrantup.com/) - v2.0,
- [landrush](https://github.com/vagrant-landrush/landrush)

Then open `Vagrantfile` and update theses lines :
- 16: your favorite local domain tld,
- 61: name of your VM (ea your project)
- 64: hostname
- 65: domain
- 67: the folder name of your project (from git clone for example). If you don't have any project, remove this line.

Or if you love make, just edit `Makefile` vars and run `make init`.

After build, feel free to handle your project as your choice. My choice is to
add a new role to Ansible (named by my app) for deploying (like in a prod environment) my project.

If you want to have multiple VM, just copy line 66 to 114 and rename "app" to "front"
and add another "back" for example. It works fine.

## Local config

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

## Deployment with Ansible

Ansible needs some modules for running:
`apt-get install python -y`

Open `ansible/hosts` and add your new server on line 1:
`<hostname> ansible_ssh_host=<ip> ansible_ssh_user='root' ansible_ssh_password='<password>'`

And <hostname> under `[prod]` group.

Add an user in corresponding host file:

```
monolith_ssh_pubkey:
  <user>:
    bash: /bin/bash
    pubkey: <corresponding ssh key>
```

Run ssh playbook:
`ansible-playbook -i ansible/hosts ansible/init.yml -t ssh -l <hostname>`

Then edit `ansible/hosts` and update the previous configuration line:
`<hostname> ansible_ssh_host=<ip> ansible_ssh_user='<user>' ansible_ssh_private_key_file='<ssh key>'`

And deploy:
`ansible-playbook -i ansible/hosts ansible/init.yml -t init -l <hostname>`
`ansible-playbook -i ansible/hosts ansible/build.yml -t build -l <hostname>`


## Code of conduct

See the [CODE OF CONDUCT](CODE_OF_CONDUCT.md) file.

## Contributing

See the [CONTRIBUTING](CONTRIBUTING.md) file.

## License

For *this* project, I choose […drumroll…] the [MIT License](LICENSE.md).

## SUPPORT

See the [SUPPORT](SUPPORT.md) file. (Don't forget to change default email/slack/...)

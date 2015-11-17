# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 1.7.2"

options = {
  :box              => 'boxcutter/debian82',
  :box_version      => '~> 2.0.2',
  :name             => 'monolith',
  :domain_tld       => 'project',
  :memory           => 1024,
  :cpu              => 1,
  :folders       => {
      '.' => '/var/www/',
  },
  :debug            => false
}

# Use rbconfig to determine if we're on a windows host or not.
require 'rbconfig'
is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Box
  config.vm.box         = options[:box]
  config.vm.box_version = options[:box_version]
  config.vm.hostname    = options[:name] + '.' + options[:domain_tld]

  # Network
  config.vm.network :private_network, type: :dhcp

  if Vagrant.has_plugin?('landrush')
      config.landrush.enabled            = true
      config.landrush.tld                = config.vm.hostname
      config.landrush.guest_redirect_dns = false
  elsif Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled     = true
    config.hostmanager.manage_host = true
    config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if vm.id
        `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
      end
    end

    config.hostmanager.aliases = %w(

    )
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :machine

    config.cache.synced_folder_opts = {
      type: :nfs,
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }

    config.cache.enable :generic
  end

  # SSH
  config.ssh.forward_agent = true

  # Synced Folders
  config.vm.synced_folder ".", "/vagrant", disabled: true

  options[:folders].each do |host, guest|
    config.vm.synced_folder host, guest, type: 'nfs', mount_options: ['nolock', 'actimeo=1', 'fsc']
  end

  # Set the name of the VM. See: http://stackoverflow.com/a/17864388/100134
  config.vm.define config.vm.hostname do |monolith_config|
  end

  # Providers

  # VMWare
  config.vm.provider :vmware_fusion do |v, override|
    v.vmx["memsize"]     = options[:memory]
    v.vmx["numvcpus"]    = options[:cpu]
    v.vmx["displayName"] = config.vm.hostname
  end

  # VirtualBox.
  config.vm.provider :virtualbox do |v|
    v.memory = options[:memory]
    v.cpus   = options[:cpu]
    v.name   = config.vm.hostname

    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  # Provisioning configuration for shell script (for Windows).
  if is_windows
    config.vm.provision "shell" do |sh|
      sh.path = "ansible/JJG-Ansible-Windows/windows.sh"
      sh.args = "ansible/build.yml"
    end
  else

    # Copy your gitconfig file to VM
    if File.exists?(File.join(Dir.home, '.gitconfig')) then
      config.vm.provision :file do |file|
        file.source      = '~/.gitconfig'
        file.destination = '/home/vagrant/.gitconfig'
      end
    end

    # Copy your composer credentials to VM
    if File.exists?(File.join(Dir.home, '.composer/auth.json')) then
      config.vm.provision :file do |file|
        file.source      = '~/.composer/auth.json'
        file.destination = '/home/vagrant/.composer/auth.json'
      end
    end

    # Provisioniers
    config.vm.provision :ansible do |ansible|
      ansible.playbook   = 'ansible/build.yml'
      ansible.verbose    = options[:debug] ? 'vvvv' : false
      ansible.sudo       = true
      ansible.tags       = ["build"]
      ansible.groups     = {
        "dev" => [config.vm.hostname],
        "provision:children" => ["dev"],
        "provision:vars" => { "isFirstRun" => true }
      }

    end

  end

end

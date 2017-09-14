# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 2.0.0"

# Use rbconfig to determine if we're on a windows host or not.
require 'rbconfig'
is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  options = {
    :box => 'debian/stretch64',
    :box_version => '~> 9.1.0',
    :domain_tld => 'project',
    :memory => 1024,
    :cpu => 1,
    :debug => false
  }

  # Box
  config.vm.box = options[:box]
  config.vm.box_version = options[:box_version]

  # Network
  config.vm.network :private_network, type: :dhcp

  # SSH
  config.ssh.forward_agent = true

  # Synced Folders
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Landrush
  config.landrush.enabled = true
  config.landrush.guest_redirect_dns = false

  # VirtualBox.
  config.vm.provider :virtualbox do |v|
    v.memory = options[:memory]
    v.cpus = options[:cpu]

    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  # Configuration for the app env
  config.vm.define "monolith" do |app|

    app_options = {
      :hostname => 'www',
      :domain   => 'monolith',
      :folders  => {
        'monolith' => '/var/www/'
      }
    }

    # Box
    app.vm.hostname = ((false === app_options[:hostname].empty?) ? (app_options[:hostname] + '.') : '') + app_options[:domain] + '.' + options[:domain_tld]
    config.landrush.tld = app.vm.hostname

    app_options[:folders].each do |host, guest|
      app.vm.synced_folder host, guest, create: true, type: 'nfs', mount_options: ['nolock', 'actimeo=1', 'fsc']
    end

    app.vm.provider :virtualbox do |v|
      v.name = app.vm.hostname
    end

    # Provisioniers
    app.vm.provision :ansible do |ansible|
      ansible.playbook = 'ansible/init.yml'
      ansible.verbose = options[:debug] ? 'vvvv' : false
      ansible.become = true
      ansible.tags = ["init"]
      ansible.groups = {
        "dev" => [app_options[:domain]],
        "provision:children" => ["dev"],
        "provision:vars" => { "isFirstRun" => true }
      }
    end

    app.vm.provision :ansible do |ansible|
      ansible.playbook = 'ansible/build.yml'
      ansible.verbose = options[:debug] ? 'vvvv' : false
      ansible.become = true
      ansible.tags = ["build"]
      ansible.groups = {
        "dev" => [app_options[:domain]],
        "provision:children" => ["dev"],
        "provision:vars" => { "isFirstRun" => true }
      }
    end
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

VAGRANTFILE_API_VERSION = '2'.freeze

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/trusty64'

  config.vm.provider 'virtualbox' do |vb|
    vb.name = 'predix-ec-configurator-box'
    vb.memory = '2048'
  end

  # check vagrant-proxyconf plugin installation
  unless Vagrant.has_plugin?('vagrant-proxyconf')
    system('vagrant plugin install vagrant-proxyconf')
    raise('vagrant-proxyconf installed. Run command again.')
  end
  # check vagrant-triggers plugin installation
  unless Vagrant.has_plugin?('vagrant-triggers')
    system('vagrant plugin install vagrant-triggers')
    raise('vagrant-triggers installed. Run command again.')
  end

  # Port forwarding between guest and host
  config.vm.network 'forwarded_port', guest: 80, host: 8080, id: 'nginx'
  config.vm.network 'forwarded_port', guest: 5432, host: 65432, id: 'postgres'

  # Load proxy.json file and set proxy for VM
  proxy_file = File.join('.', 'proxy.json')
  if File.exist?(proxy_file)
    proxy_settings = JSON.parse(File.read(proxy_file))
    unless proxy_settings['url'].empty?
      config.proxy.http     = proxy_settings['url']
      config.proxy.https    = proxy_settings['url']
      config.proxy.no_proxy = 'localhost,127.0.0.1'
    end
  end

  # Share the folder between host and VM
  config.vm.synced_folder '.', '/vagrant'

  # Do it once
  config.vm.provision 'shell', path: 'scripts/provision.sh'
  config.vm.provision 'file',
                      source: 'config.json',
                      destination: File.join('/home/vagrant', 'config.json')

  # Do it everytime you run the VM
  config.trigger.after :up do
    run_remote 'source /vagrant/scripts/ec_configurator_start.sh'
  end
end

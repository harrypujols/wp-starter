# -*- mode: ruby -*-
# vi: set ft=ruby :

PORT='8000'

Vagrant.configure('2') do |config|
  config.vm.box = 'bento/ubuntu-16.04'
  config.vm.network 'forwarded_port', guest: 80, host: PORT
  config.vm.synced_folder './src', '/home/vagrant/shared', :mount_options => ['dmode=777','fmode=666']
  config.vm.provision :shell, path: 'provision.sh', args: PORT
end

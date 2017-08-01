# -*- mode: ruby -*-
# vi: set ft=ruby :

PORT='8000'

Vagrant.configure('2') do |config|
  config.vm.box = 'harrypujols/wp-starter'
  config.vm.network 'forwarded_port', guest: 80, host: PORT
  config.vm.network :forwarded_port, guest: 22, host: 2200, id: 'ssh', auto_correct: true
  config.vm.synced_folder './src', '/var/www/html/wp-content/themes/wp-starter', :mount_options => ['dmode=777','fmode=666']
  config.vm.provision "shell", privileged: false, run: "always", inline: <<-EOF
    printf "\033[0;36mYour server is running at \033[0;35mhttp://localhost:#{PORT}\033[0m"
  EOF
end

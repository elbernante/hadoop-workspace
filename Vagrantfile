# -*- mode: ruby -*-
# vi: set ft=ruby :

# To start VM with GUI, run command:
# GUI=1 vagrant up
# 
# To disable GUI, run command:
# GUI=0 vagrant up

def gui_enabled?
  gf = ENV.fetch('GUI', '')
  !(['0', 'false'].include?(gf) | gf.empty?)
end

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine.]
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 9000, host: 9000   # Hadoop core site
  config.vm.network "forwarded_port", guest: 8088, host: 8088   # Hadoop YARN Resource Manager
  config.vm.network "forwarded_port", guest: 50030, host: 50030 # Hadoop Jobtracker history server
  config.vm.network "forwarded_port", guest: 50070, host: 50070 # Hadoop Name node

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = gui_enabled?
  
    # Customize the amount of memory on the VM:
    vb.memory = "2048"

    # Set name
    vb.name = "ubuntu_trusty64_hadoop"
  end

  # Install libraries
  config.vm.provision "shell", path: "pg_config.sh"
end

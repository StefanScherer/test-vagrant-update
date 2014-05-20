# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.6.2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ferventcoder/win7pro-x64-nocm-lite"
  config.vm.hostname = "win7"
  config.vm.communicator = "winrm"

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", 768]
    vb.customize ["modifyvm", :id, "--cpus", 1]
    vb.customize ["modifyvm", :id, "--vram", "32"]
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
  end

  config.vm.provision "shell", path: "scripts/install_vagrant_1.5.3.ps1"
  config.vm.provision "shell", path: "scripts/install_vagrant_1.6.2.ps1"
  config.vm.provision "shell", path: "scripts/check_bsdtar.ps1"
  config.vm.provision "shell", path: "scripts/check_vagrant_box_add.ps1"
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

require "vagrant-host-shell"
require "vagrant-junos"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  #VM1
  #Student VM
  config.vm.define "dev", primary: true do |dev|
    dev.vm.box = "ubuntu/xenial64"
    dev.vm.hostname = "netdev-vm"
    dev.vm.network "private_network",
                   ip: "172.16.0.10",
                   virtualbox__intnet: "NetDevOps-StudentInternal"
    dev.vm.synced_folder ".", "/vagrant"
    #dev.ssh.password = "vagrant"
    #Virtualbox
    dev.vm.provider "virtualbox" do |v|
      v.gui = false
      v.customize ["modifyvm", :id, "--memory", "512"]
    end

    #Provisioning
    dev.vm.provision "shell" do |s|
      # this script provisions the ndo box for you
      s.path = "scripts/dev-setup.sh"
    end
    #dev.vm.provision "shell" do |s|
    #  # this script provisions the ndo box for you
    #  s.inline = "ansible-playbook /vagrant/scripts/site.yml"
    #end
  end

  #VM2
  #Student SRX R1
  config.vm.define "srx_r1" do |srx|
    srx.vm.box = "juniper/ffp-12.1X47-D15.4-packetmode"
    srx.vm.hostname = "R1"
    srx.vm.network "private_network",
                   ip: "10.10.0.10",
                   netmask: "255.255.252.0",
                   nic_type: 'virtio',
                   virtualbox__intnet: "NetDevOps-Public"
    srx.vm.network "private_network",
                   ip: "172.16.0.1",
                   nic_type: 'virtio',
                   virtualbox__intnet: "NetDevOps-StudentInternal"
    srx.vm.network "private_network",
                   ip: "172.15.0.1",
                   netmask: "255.255.255.0",
                   nic_type: 'virtio',
                   virtualbox__intnet: "NetDevOps-StudentInternal-2"
    srx.vm.synced_folder "", "/vagrant", disabled: true

    #Virtualbox
    srx.vm.provider "virtualbox" do |v|
      # increase RAM to support AppFW and IPS
      # comment out to make it run at 2GB
      v.customize ["modifyvm", :id, "--memory", "1024"]
      v.check_guest_additions = false
    end

    #Provisioning
    srx.vm.provision "file", source: "scripts/srx-r1-setup.sh", destination: "/tmp/srx-setup.sh"
    srx.vm.provision :host_shell do |host_shell|
      # provides the inital configuration
      host_shell.inline = 'vagrant ssh srx_r1 -c "/usr/sbin/cli -f /tmp/srx-setup.sh"'
    end
  end

  #VM 3
  #Student SRX R2
  config.vm.define "srx_r2" do |srx|
    srx.vm.box = "juniper/ffp-12.1X47-D15.4-packetmode"
    srx.vm.box_version = ">= 0.5.0"
    srx.vm.hostname = "R2"
    srx.vm.network "private_network",
                   ip: "10.10.0.5",
                   netmask: "255.255.252.0",
                   nic_type: 'virtio',
                   virtualbox__intnet: "NetDevOps-Public"
    srx.vm.network "private_network",
                   nic_type: 'virtio',
                   virtualbox__intnet: "NetDevOps-Private"
    srx.vm.network "private_network",
                   ip: "192.168.10.1",
                   nic_type: 'virtio',
                   virtualbox__intnet: "NetDevOps-Private"
    srx.vm.synced_folder "", "/vagrant", disabled: true

    #Virtualbox
    srx.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "1024"]
      v.check_guest_additions = false
    end

    srx.vm.provision "file", source: "scripts/srx-r2-setup.sh", destination: "/tmp/srx-setup.sh"
    #srx.vm.provision "file", source: "scripts/headend-srx-vpnstints.sh", destination: "/tmp/srx-vpnstints.sh"
    srx.vm.provision :host_shell do |host_shell|
      host_shell.inline = 'vagrant ssh srx_r2 -c "/usr/sbin/cli -f /tmp/srx-setup.sh"'
    end
    #srx.vm.provision :host_shell do |host_shell|
    #    host_shell.inline = 'vagrant ssh srx_r2 -c "/usr/sbin/cli -f /tmp/srx-vpnstints.sh"'
    #end
  end
end

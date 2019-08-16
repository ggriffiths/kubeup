# -*- mode: ruby -*-
# vi: set ft=ruby :

NODES = 3
DISKS = 3
MEMORY = 4096
CPUS = 4
NESTED = true

### TYPE HERE A PREFIX ###
PREFIX = "grant-k8s"

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false
    config.vm.box = "centos/7"

    # Override
    config.vm.provider :libvirt do |v,override|
        override.vm.synced_folder '.', '/home/vagrant/sync', disabled: true
    end

    # Make kub master
    config.vm.define "#{PREFIX}-master" do |master|
        master.vm.network :private_network, ip: "192.168.30.80"
        master.vm.host_name = "#{PREFIX}-master"

        master.vm.provider :libvirt do |lv|
            lv.memory = MEMORY
            lv.cpus = CPUS
            lv.nested = NESTED
        end

    end

    # Make the glusterfs cluster, each with DISKS number of drives
    (0..NODES-1).each do |i|
        config.vm.define "#{PREFIX}-node#{i}" do |node|
            node.vm.hostname = "#{PREFIX}-node#{i}"
            node.vm.network :private_network, ip: "192.168.30.9#{i}"

			node.vm.provider :libvirt do |v,override|
				override.vm.synced_folder '.', '/home/vagrant/sync', disabled: true
			end

            (0..DISKS-1).each do |d|
                node.vm.provider :libvirt do  |lv|
                    driverletters = ('b'..'z').to_a
                    lv.storage :file, :device => "vd#{driverletters[d]}", :path => "#{PREFIX}-disk-#{i}-#{d}.disk", :size => '1024G'
                    lv.memory = MEMORY
                    lv.cpus = CPUS
                    lv.nested = NESTED
                end
            end

            if i == (NODES-1)
                # View the documentation for the provider you're using for more
                # information on available options.
                node.vm.provision :ansible do |ansible|
                    ansible.limit = "all"
                    ansible.playbook = "site.yml"
                    ansible.groups = {
                        "master" => ["#{PREFIX}-master"],
                        "nodes" => (0..NODES-1).map {|j| "#{PREFIX}-node#{j}"},
                    }
                end
            end
        end
    end
end

Vagrant.configure("2") do |config|
    servers=[
        {
          :hostname => "MUMDCNODE1",
          :box => "generic/oracle8",
          :ip => "192.168.1.71",
          :ssh_port => '2200'
        },
        {
          :hostname => "MUMDCNODE2",
          :box => "generic/oracle8",
          :ip => "192.168.1.72",
          :ssh_port => '2201'
        },
        {
          :hostname => "MUMDCNODE3",
          :box => "generic/oracle8",
          :ip => "192.168.1.73",
          :ssh_port => '2202'
        }
      ]



      servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.vm.hostname = machine[:hostname]
            node.vm.network :public_network, ip: machine[:ip]
            node.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"
            node.vm.synced_folder 'G:\Windows_Installer_ISOs\Oracle_RAC_19c_Linux_GRID_Infrastructure', "/home/vagrant/data"
            node.vm.provision "shell", path: "script.sh"

            node.vm.provider :vmware_workstation do |vb|
                vb.gui = true
                vb.cpus = '4'
                vb.memory = '8192'
                vb.linked_clone = false
            end
        end
    end
end

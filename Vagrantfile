Vagrant.configure("2") do |config|

    # Set up some box defaults.  We're going to use the Puppetlabs
    # CentOS 6.4 x86_64 base boxe, and give it 1GB RAM

    box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-%s.box'

    config.vm.box = 'puppet_centos64'
    config.vm.box_url = sprintf(box_url, 'vbox4210')

    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "1024"]
    end

    config.vm.provider 'vmware_fusion' do |v,override|
        override.vm.box_url = sprintf(box_url, 'fusion503')
        v.vmx["memsize"] = "1024"
    end

    # Private networking lets us reach this box on its own address.
    # The network will not be accessible outside of this machine.

    config.vm.network :private_network, ip: "10.8.8.10"


    # Set up some Puppet "facts".  These will be available to the
    # puppet manifests when they run.

    puppet_facts = {
        "vagrant" => "1",
        "roles"   => [ 'webserver', 'database' ]
    }


    # Some magic to make sure we use a local package mirror if one is
    # available - so that demoing doesn't require a network connection
    # that works properly.

    if File.exists?( File.join( ENV['HOME'], 'mirror', 'CentOS', '6' ) )
        config.vm.synced_folder "#{ENV['HOME']}/mirror", "/mirror"
        puppet_facts["has_local_package_mirror"] = "1"
    end


    # Provision the Vagrant box using Puppet.

    config.vm.provision "puppet" do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file  = "site.pp"
        puppet.module_path    = "puppet/modules"
        puppet.facter         = puppet_facts
    end

end

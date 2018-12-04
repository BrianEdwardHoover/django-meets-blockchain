# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  	# Base box to build off, and download URL for when it doesn't exist on the user's system already
	config.vm.box = "bento/ubuntu-18.04"

	# Forward a port from the guest to the host, which allows for outside
	# computers to access the VM, whereas host only networking does not.
	config.vm.forward_port 8000, 8000

	# Share an additional folder to the guest VM. The first argument is
	# an identifier, the second is the path on the guest to mount the
	# folder, and the third is the path on the host to the actual folder.
	config.vm.share_folder "project", "/home/vagrant/dmb-api", "."

	# Enable provisioning with a shell script.
	config.vm.provision :shell, :path => "etc/install/install.sh", :args => "dmb-api"
end

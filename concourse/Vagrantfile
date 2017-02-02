Vagrant.configure("2") do |config|
  config.vm.box = "cloudfoundry/bosh-lite"

   config.vm.provider "virtualbox" do |vb, override|
     vb.cpus = 2
     vb.memory = "4096"
     override.vm.box_version = '9000.137.0' # ci:replace
   end
end

# Docker and virtualization lab2

## Install the vagrant-disksize plugin to set the disk size
```bash
vagrant plugin install vagrant-disksize
```

## Vagrantfile content
```bash
cat Vagrantfile
```

```bash
VAGRANT_EXPERIMENTAL="disks"

Vagrant.configure("2") do |config|
  config.vm.box = "generic/rocky8"
  config.disksize.size = "20GB"
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end
end
```

## Bring the VM up
```bash
vagrant up
```

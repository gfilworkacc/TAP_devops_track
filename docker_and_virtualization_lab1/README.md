# Docker and virtualization lab1 

## Run script "create_vm.sh" to create the virtual machine and see it's information
```bash
#!/usr/bin/env bash

vm_directory="/home/$USER/test_vm"
vm_name="rocky_linux"
vm_image="/home/$USER/Downloads/Rocky-8.4-x86_64-minimal.iso"

#Create and register the VM:
vboxmanage createvm --name "$vm_name" --ostype "RHEL_64" --register --basefolder "$vm_directory" &>/dev/null

#Set vm's resources - memory and CPU:
vboxmanage modifyvm "$vm_name" --memory 1024

vboxmanage modifyvm "$vm_name" --cpus 2

#Set the hdd:
vboxmanage createhd --filename "$vm_directory"/"$vm_name"/"$vm_name"_disk.vdi --size 20000 &>/dev/null

vboxmanage storagectl "$vm_name" --name "SATA" --add sata --controller IntelAHCI

vboxmanage storageattach "$vm_name" --storagectl "SATA" --port 0 --device 0 --type hdd --medium  "$vm_directory"/"$vm_name"/"$vm_name"_disk.vdi

#Set CD and insert ISO image
vboxmanage storagectl "$vm_name" --name "IDE" --add ide --controller PIIX4  

vboxmanage storageattach "$vm_name" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium "$vm_image"

#Check the VM details in vm_directory
vboxmanage showvminfo "$vm_name" > "$vm_directory"/"$vm_name"_info
```

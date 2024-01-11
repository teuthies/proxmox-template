#!/bin/bash
set -o errexit


# default settings which are used for the templates
MEMORY=4096
BRIDGE=vmbr1
VLANID=11
BIOS=ovmf
MACHINE=q35
CORE=4
STORAGE=fast1

printf "* Available templates to generate:\n 1) Ubuntu Server 22.04 LTS (Jammy Jellyfish)\n 2) Debian 12 (Bokkworm)\n\n"
read -p "* Enter number of distro to use: " OSNR

case $OSNR in

  1)
    OSNAME=ubuntu
    VMID_DEFAULT=8100
    read -p "Enter a VM ID for $OSNAME [$VMID_DEFAULT]: " VMID
    VMID=${VMID:-$VMID_DEFAULT}
    VMIMAGE=jammy-server-cloudimg-amd64.img
    NOTE="\n## Default user is 'ubuntu'\n"
    printf "$NOTE\n"
    wget -P /tmp -N https://cloud-images.ubuntu.com/jammy/current/$VMIMAGE
    ;;

  2)
    OSNAME=debian
    VMID_DEFAULT=8200
    read -p "Enter a VM ID for $OSNAME [$VMID_DEFAULT]: " VMID
    VMID=${VMID:-$VMID_DEFAULT}
    VMIMAGE=debian-12-genericcloud-amd64.qcow2
    NOTE="\n## Default user is 'debian'\n"
    printf "$NOTE\n"
    wget -P /tmp -N https://cloud.debian.org/images/cloud/bookworm/latest/$VMIMAGE
    ;;

  *)
    printf "\n** Unknown OS number. Please use one of the above!\n"
    exit 0
    ;;
esac

printf "\n** Creating a VM with $MEMORY MB using network bridge $BRIDGE\n"
qm create $VMID --name $OSNAME-cloud --memory $MEMORY --net0 virtio,bridge=$BRIDGE,tag=$VLANID --core $CORE --machine $MACHINE --bios $BIOS 

printf "\n** Adding an EFI disk (as 'Disk 0')\n"
qm set $VMID --efidisk0 $STORAGE:0,efitype=4m

printf "\n** Importing the disk in qcow2 format (as 'Unused Disk 1')\n"
qm importdisk $VMID /tmp/$VMIMAGE $STORAGE

printf "\n** Attaching the disk to the vm using VirtIO SCSI\n"
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$VMID-disk-1,ssd=1

printf "\n** Creating a cloudinit drive managed by Proxmox\n"
qm set $VMID --ide2 $STORAGE:cloudinit

printf "\n** Setting boot disk and display settings with serial console\n"
qm set $VMID --boot c --bootdisk scsi0  --serial0 socket --vga serial0

printf "\n** Using a dhcp server on $BRIDGE VLAN $VLANID\n"
qm set $VMID --ipconfig0 ip=dhcp

printf "\n** Add user to cloudinit in GUI\n"
printf "\n** Add password to cloudinit in GUI\n"
printf "\n** Add ssh key to cloudinit in GUI\n"
printf "\n** Convert to a template in GUI\n"
printf "\n** Create a full clone out of the template in GUI\n"
printf "\n****** You are done ******\n"
#!/bin/bash
set -o errexit

printf "* Available templates to generate:\n 1) Ubuntu Server 22.04 LTS (Jammy Jellyfish)\n 2) Debian 12 (Bokkworm)\n\n"
read -p "* Enter number of distro to use: " OSNR

case $OSNR in

  1)
    OSNAME=ubuntu2204
    VMID_DEFAULT=8100
    read -p "Enter a VM ID for $OSNAME [$VMID_DEFAULT]: " VMID
    VMID=${VMID:-$VMID_DEFAULT}
    VMIMAGE=jammy-server-cloudimg-amd64.img
    NOTE="\n## Default user is 'ubuntu'\n"
    printf "$NOTE\n"
    wget -P /tmp -N https://cloud-images.ubuntu.com/jammy/current/$VMIMAGE
    ;;

  2)
    OSNAME=debian12
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

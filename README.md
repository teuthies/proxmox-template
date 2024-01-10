# Perfect Proxmox Template with Cloud Image and Cloud Init

Using Cloud Images and Cloud Init with Proxmox is easy, fast, efficient, and fun! 

Cloud Images are small images that are certified cloud ready that have Cloud Init preinstalled and ready to accept a Cloud Config.

Cloud Images and Cloud Init also work with Proxmox and if you combine the two you have a perfect, small, efficient, optimized clone template to provision machines with your ssh keys and network settings.

Based on Techno Tim Tutorial https://technotim.live/posts/cloud-init-cloud-image/

## Instructions

Choose your Ubuntu Cloud Image https://cloud-images.ubuntu.com/
or Debian Cloud Image https://cloud.debian.org/images/cloud/

Download Cloud Image (replace with the url of the one you chose from above):
```
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
```
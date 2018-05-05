# vagrant-k8s
A Vagrant project to create a local Kubernetes cluster

## Requirements
 - VirtualBox
 - Vagrant
 - The Vagrant reload plugin: `vagrant plugin install vagrant-reload`

## Usage
*Default values*
`vagrant up`

*Custom values*
`vagrant --workers=2 --cpus=3 --memory=2048 --ip-prefix='192.168.10' --last-octet-base=200 up`
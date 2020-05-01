#! /bin/bash

sudo service mysql stop &&
sudo service teamviewerd stop &&
sudo service apache2 stop &&
sudo service apache-htcacheclean stop &&
sudo service qemu-kvm stop &&
sudo service libvirt-guests stop &&
sudo service libvirt-bin stop

#!/usr/bin/env bash

# Install packages required to setup OpenShift.
sudo yum -y install epel-release
sudo yum -y update all
sudo yum -y install -y wget git gettext ansible docker nodejs npm gcc-c++ bzip2
yum -y install python-docker-py


# Docker setup. Check the version with `docker version`, should be 1.12.
yum install -y docker

# Creating the docker storage setup to ensure we have a docker thin pool 
cat <<EOF > /etc/sysconfig/docker-storage-setup
DEVS=/dev/xvdf
VG=docker-vg
EOF

# Configuring and installating Docker
docker-storage-setup

# Restart docker and go to clean state as required by docker-storage-setup.
systemctl stop docker
rm -rf /var/lib/docker/*
systemctl start docker
systemctl enable docker
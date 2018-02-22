#!/usr/bin/env bash

# Install packages required to setup OpenShift.
sudo yum -y install epel-release
sudo yum -y update all
sudo yum -y install -y wget git gettext ansible docker nodejs npm gcc-c++ bzip2 vim
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

# Becoming Root for the next steps
sudo su -
git clone https://github.com/ansible/awx.git

# Editing the default values for the inventory file
sed -i.bak "s/# default_admin_user=admin/default_admin_user=\$ToBeChanged/" ~/awx/installer/inventory
sed -i.bak "s/# default_admin_password=password/default_admin_password=\$ToBeChanged/" ~/awx/installer/inventory
sed -i.bak "s/awx_secret_key=awxsecret/awx_secret_key=\$ToBeChanged/" ~/awx/installer/inventory
sed -i.bak "s/pg_username=awx/pg_username=\$ToBeChanged/" ~/awx/installer/inventory
sed -i.bak "s/pg_password=awxpass/pg_password=\$ToBeChanged/" ~/awx/installer/inventory
sed -i.bak "s/pg_database=awx/pg_database=\$ToBeChanged/" ~/awx/installer/inventory

# Launching the installation via Playbook
ansible-playbook -i ~/awx/installer/inventory ~/awx/installer/install.yml
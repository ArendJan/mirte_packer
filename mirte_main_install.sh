#!/bin/bash
set -xe
echo $type
chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo # something with sudo otherwise complaining about "sudo: /usr/bin/sudo must be owned by uid 0 and have the setuid bit set"
. /usr/local/src/mirte/settings.sh
mkdir /usr/local/src/mirte/build_system/ || true
apt update
systemctl disable armbian-resize-filesystem
apt install -y git python3-pip
git --version
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt install curl # if you haven't already installed curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
apt update
apt install -y python3-vcstool python3-pip python3-dev libblas-dev liblapack-dev libatlas-base-dev gfortran
cd /usr/local/src/mirte/
ls -al
vcs import --workers 1 --input ./repos.yaml || true
pip3 install "deepdiff[cli]"
deep diff --ignore-order --ignore-string-case ./repos.yaml ./mirte-install-scripts/repos.yaml # to show the difference between the repos.yaml in here and in mirte-install-scripts/repos.yaml
cp ./repos.yaml ./mirte-install-scripts/repos.yaml # overwrite the repos.yaml in mirte-install-scripts with the one in here
ls -al
cd /usr/local/src/mirte/mirte-install-scripts/ && ./create_user.sh
echo 'mirte ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
chown -R mirte /usr/local/src/mirte/*

if [[ "$type" == "mirteopi" ]]; then
    pip3 install /usr/local/src/mirte/wheels/*
fi
rm -rf /usr/local/src/mirte/wheels
sudo -i -u mirte bash -c 'export MAKEFLAGS=\"-j$(nproc)\"; cd /usr/local/src/mirte/mirte-install-scripts/ && ./install_mirte.sh'
sed -i '$ d' /etc/sudoers
if $EXPIRE_PASSWD; then passwd --expire mirte; fi
if $INSTALL_NETWORK; then /usr/local/src/mirte/mirte-install-scripts/network_install.sh; fi
# for script in $${EXTRA_SCRIPTS[@]}; do /usr/local/src/mirte/$script; done
mkdir /mnt/mirte # create mount point and automount it
if $INSTALL_PROVISIONING; then echo 'UUID="9EE2-A262" /mnt/mirte/ vfat rw,relatime,uid=1000,gid=1000,errors=remount-ro 0 0' >>/etc/fstab; fi

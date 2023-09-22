packer {
  required_plugins {
    arm-image = {
      version = ">= 0.2.9"
      source  = "github.com/arendjan/arm-image"
    }
  }
}

source "arm-image" "mirteopi2" {
  image_type = "armbian"
  iso_url = "https://archive.armbian.com/orangepizero2/archive/Armbian_22.02.2_Orangepizero2_focal_legacy_4.9.255.img.xz"
  iso_checksum = "sha256:d2a6e59cfdb4a59fbc6f8d8b30d4fb8c4be89370e9644d46b22391ea8dff701d"
  output_filename = "./workdir/mirteopi2.img"
  target_image_size = 15*1024*1024*1024
}

source "arm-image" "mirteopi" {
  image_type = "armbian"
  iso_url = "https://archive.armbian.com/orangepizero/archive/Armbian_21.02.3_Orangepizero_focal_current_5.10.21.img.xz"
  iso_checksum = "sha256:44ceec125779d67c1786b31f9338d9edf5b4f64324cc7be6cfa4a084c838a6ca"
  output_filename = "./workdir/mirteopi.img"
  target_image_size = 15*1024*1024*1024
}

# source "arm-image" "hostapd" {
#   iso_url = "https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2020-02-14/2020-02-13-raspbian-buster-lite.zip"
#   iso_checksum = "sha256:12ae6e17bf95b6ba83beca61e7394e7411b45eba7e6a520f434b0748ea7370e8"
#   output_filename = "./build/hostpad.img"
#   target_image_size = 3*1024*1024*1024
# }149DFCB01EF25F08

build {
  sources = ["source.arm-image.mirteopi2", "source.arm-image.mirteopi"]
  provisioner "file" {
    source = "git_local"
    destination = "/usr/local/src/mirte"
  }
  provisioner "file" {
    source = "repos.yaml"
    destination = "/usr/local/src/mirte/"
  }
  provisioner "file" {
    source = "settings.sh"
    destination = "/usr/local/src/mirte/"
  }
 provisioner "shell" {
    inline_shebang = "/bin/bash -e"
    inline = [
      ". /usr/local/src/mirte/settings.sh",
      "apt update",
      "systemctl disable armbian-resize-filesystem",
      "apt install -y git",
      "git --version",
      "sh -c 'echo \"deb http://ftp.tudelft.nl/ros/ubuntu $(lsb_release -sc) main\" > /etc/apt/sources.list.d/ros-latest.list'",
      "curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add -",
      "apt update",
      "apt install -y python3-vcstool",
      "cd /usr/local/src/mirte/",
      "ls -al",
      "vcs import --workers 1 --input ./repos.yaml|| true",
      "ls -al",
      "cd /usr/local/src/mirte/mirte-install-scripts/ && ./create_user.sh",
      "echo 'mirte ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers",
      "chown -R mirte /usr/local/src/mirte/*",
      "sudo -i -u mirte bash -c 'cd /usr/local/src/mirte/mirte-install-scripts/ && ./install_mirte.sh'",
      "sed -i '$ d' /etc/sudoers",
      "if $EXPIRE_PASSWD;then passwd --expire mirte; fi",
      "if $INSTALL_NETWORK;then /usr/local/src/mirte/mirte-install-scripts/network_install.sh; fi",
      "for script in $${EXTRA_SCRIPTS[@]}; do /usr/local/src/mirte/$script; done"
    ]
  }
}


# build {
#   sources = ["source.arm-image.hostapd", "source.arm-image.mirteopi2"]

#  provisioner "shell" {
#     inline = [
        
#           "ping -c 10 ports.ubuntu.com",
#           #   "apt install -y git",
#           #   "mkdir -p /usr/local/src/mirte/",
#           #   "cd /usr/local/src/mirte/ &&   git clone https://github.com/arendjan/mirte-install-scripts.git",
#           #   "cd mirte-install-scripts",
#           #   "ls -al",
#           #   "git checkout parralel-jobs",
#           #   "ls -al",
#           #   "echo 'downloaded'",
#           #   "cd /usr/local/src/mirte/mirte-install-scripts/ && ./create_user.sh",
#           #   "echo 'mirte ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers",
#           #   "-i -u mirte bash -c 'cd /usr/local/src/mirte/mirte-install-scripts/ && ./install_mirte.sh'",
#           #   "sed -i '$ d' /etc/sudoers",
#           #   "# passwd --expire mirte",
#           #   "/usr/local/src/mirte/mirte-install-scripts/network_install.sh"
#     ]
#   }
# }

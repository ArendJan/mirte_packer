packer {
  required_plugins {
    arm-image = {
      version = ">= 0.2.5"
      source  = "github.com/solo-io/arm-image"
    }
  }
}

source "arm-image" "mirteopi2" {
  image_type = "armbian"
  iso_url = "./build/mirteopiOri.img"
  iso_checksum = "sha256:eadc354e3a48e73b00a81af1d1a96ccb506228efd61a4ec99febd06fe1553ef2"
  output_filename = "./build/mirteopi2T.img"
  target_image_size = 10*1024*1024*1024
}

# source "arm-image" "hostapd" {
#   iso_url = "https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2020-02-14/2020-02-13-raspbian-buster-lite.zip"
#   iso_checksum = "sha256:12ae6e17bf95b6ba83beca61e7394e7411b45eba7e6a520f434b0748ea7370e8"
#   output_filename = "./build/hostpad.img"
#   target_image_size = 3*1024*1024*1024
# }
# source "arm-image" "armbian" {
#           type = "arm-image"

#     iso_url      = "https://archive.armbian.com/orangepizero2/archive/Armbian_22.02.2_Orangepizero2_focal_legacy_4.9.255.img.xz"

#   iso_checksum = "sha256:d2a6e59cfdb4a59fbc6f8d8b30d4fb8c4be89370e9644d46b22391ea8dff701d"
# output_filename = "./image/op02.img"
#   target_image_size = 3*1024*1024*1024

# }

build {
  sources = ["source.arm-image.mirteopi2"]
  provisioner "file" {
    source = "git_local"
    destination = "/usr/local/src/mirte"
  }
 provisioner "shell" {
    inline = [
         "apt-get update",
         "ls /usr/local/src/mirte/git_local",
          # "# ping -c 10 ports.ubuntu.com",
          #   "apt-get install -y git",
          #  "cd /usr/local/src/mirte/mirte-install-scripts/ && ./create_user.sh",
          #   "echo 'mirte ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers",
          #   "sudo chown -R mirte /usr/local/src/mirte/*",
          #   "sudo -i -u mirte bash -c 'cd /usr/local/src/mirte/mirte-install-scripts/ && ./install_mirte.sh'",
          #   "sudo sed -i '$ d' /etc/sudoers",
          #   "# sudo passwd --expire mirte",
          #   "/usr/local/src/mirte/mirte-install-scripts/network_install.sh",
            "/usr/local/src/mirte/git_local/buildRos.sh",
            "/usr/local/src/mirte/git_local/buildRos1.sh",
            "/usr/local/src/mirte/git_local/buildRos2.sh"
    ]
  }
}


# build {
#   sources = ["source.arm-image.hostapd", "source.arm-image.mirteopi2"]

#  provisioner "shell" {
#     inline = [
        
#           "# ping -c 10 ports.ubuntu.com",
#           #   "apt-get install -y git",
#           #   "mkdir -p /usr/local/src/mirte/",
#           #   "cd /usr/local/src/mirte/ &&   git clone https://github.com/arendjan/mirte-install-scripts.git",
#           #   "cd mirte-install-scripts",
#           #   "ls -al",
#           #   "git checkout parralel-jobs",
#           #   "ls -al",
#           #   "echo 'downloaded'",
#           #   "cd /usr/local/src/mirte/mirte-install-scripts/ && ./create_user.sh",
#           #   "echo 'mirte ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers",
#           #   "sudo -i -u mirte bash -c 'cd /usr/local/src/mirte/mirte-install-scripts/ && ./install_mirte.sh'",
#           #   "sudo sed -i '$ d' /etc/sudoers",
#           #   "# sudo passwd --expire mirte",
#           #   "/usr/local/src/mirte/mirte-install-scripts/network_install.sh"
#     ]
#   }
# }

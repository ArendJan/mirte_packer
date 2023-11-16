packer {
  required_plugins {
    arm-image = {
      version = ">= 0.2.10"
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
  qemu_binary = "qemu-aarch64-static"
}
source "arm-image" "mirteopi3b" {
    image_type = "armbian"

  iso_url = "/home/robohouse/mirte_packer/custom_arm/Armbian_23.11.0-trunk_Orangepi3b_focal_legacy_5.10.160.img"
  iso_checksum = "sha256:ef2f813f5a7b14d38ca908067b780a1b29877349945434efb129e14a55cd9afd"
  output_filename = "./workdir/mirteopi3b.img"
  target_image_size = 15*1024*1024*1024
  qemu_binary = "qemu-aarch64-static"
    # image_mounts = ["/", "../sadf/"]

}

source "arm-image" "mirteopi4lts" {
  image_type = "armbian"
  iso_url = "/home/robohouse/mirte_packer/custom_arm/Armbian_23.11.0-trunk_Orangepi4-lts_focal_current_6.1.62.img"
  iso_checksum = "none"
  output_filename = "./workdir/mirteopi4lts.img"
  target_image_size = 15*1024*1024*1024
  qemu_binary = "qemu-aarch64-static"
      # image_mounts = ["/"]

}

source "arm-image" "mirteopi" {
  image_type = "armbian"
  iso_url = "https://archive.armbian.com/orangepizero/archive/Armbian_21.02.3_Orangepizero_focal_current_5.10.21.img.xz"
  iso_checksum = "sha256:44ceec125779d67c1786b31f9338d9edf5b4f64324cc7be6cfa4a084c838a6ca"
  output_filename = "./workdir/mirteopi.img"
  target_image_size = 15*1024*1024*1024
}

build {
  sources = ["source.arm-image.mirteopi2", "source.arm-image.mirteopi",  "source.arm-image.mirteopi3b",  "source.arm-image.mirteopi4lts"]
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
  provisioner "file"  {
    source = "wheels"
    destination = "/usr/local/src/mirte/wheels/"
  }
  provisioner "file"  {
    source = "mirte_main_install.sh"
    destination = "/usr/local/src/mirte/"
  }
 provisioner "shell" {
    inline_shebang = "/bin/bash -e"
    inline = [
      "chmod +x /usr/local/src/mirte/mirte_main_install.sh",
      "export type=${source.name}",
      "echo $type",
      "sudo -E /usr/local/src/mirte/mirte_main_install.sh"
    ]
  }
  # provisioner "file" { # Provide the logs to the sd itself, doesn't work as tee deletes it and packer is missing it
  #   source = " logs/current_log.txt"
  #   destination = "/usr/local/src/mirte/build_system/"
  # }
  provisioner "file" { # provide the build script
    source = "build.pkr.hcl"
    destination = "/usr/local/src/mirte/build_system/"
  }
}
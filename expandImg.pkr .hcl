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
  iso_url = "build/mirteopi2.img"
  iso_checksum = "sha256:d2a6e59cfdb4a59fbc  6f8d8b30d4fb8c4be89370e9644d46b22391ea8dff70f1d"
  output_filename = "./build/mirteopi2.img"
  target_image_size = 15*1024*1024*1024
}


build {
  sources = ["source.arm-image.mirteopi2"]
  
 provisioner "shell" {
    inline_shebang = "/bin/bash -e"
    inline = [
      "ls"
    ]
  }
}

set -xe
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer
packer init build.pkr.hcl
go help || (snap install go --classic || (echo "You need to install go yourself" && exit))

git clone https://github.com/solo-io/packer-plugin-arm-image.git
cd packer-plugin-arm-image

go mod download
go build
if [ -d "$HOME/.packer.d" ]; then
	cp packer-plugin-arm-image ~/.packer.d/plugins/github.com/solo-io/arm-image/packer-plugin-arm-image_v0.2.7_x5.0_linux_amd64
	sha256sum packer-plugin-arm-image | cut -d " " -f 1 | sudo tee ~/.packer.d/plugins/github.com/solo-io/arm-image/packer-plugin-arm-image_v0.2.7_x5.0_linux_amd64_SHA256SUM
fi
if [ ! -d "$HOME/.config/packer" ]; then
	cp packer-plugin-arm-image ~/.config/packer/plugins/github.com/solo-io/arm-image/packer-plugin-arm-image_v0.2.7_x5.0_linux_amd64
	sha256sum packer-plugin-arm-image | cut -d " " -f 1 | sudo tee ~/.config/packer/plugins/github.com/solo-io/arm-image/packer-plugin-arm-image_v0.2.7_x5.0_linux_amd64_SHA256SUM
fi
cd ..
rm -rf packer-plugin-arm-image

sudo apt-get update
sudo apt-get install -y python3-vcstool

wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh -O pishrink.sh
chmod +x pishrink.sh

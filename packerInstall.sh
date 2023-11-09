set -xe

if ! which packer; then
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer
fi
packer init build.pkr.hcl
sudo packer init build.pkr.hcl

if [ ! -f "pishrink.sh" ]; then
wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh -O pishrink.sh
chmod +x pishrink.sh
fi

cp -n default.settings.sh settings.sh
cp -n default_repos.yaml repos.yaml

set -xe

REMOVE_GIT_LOCAL=false
if [ ! -d git_local ]; then
REMOVE_GIT_LOCAL=true
echo "Downloading git stuff"
mkdir git_local
cd git_local
# Download all Mirte repositories
vcs import < ../repos.yaml --workers 1 || true
cd ..
fi
PACKER_CONFIG_DIR=$HOME /usr/bin/time -v  sudo -E $(which packer) build .  | tee log.txt

if [ "$REMOVE_GIT_LOCAL" ]; then
rm -rf git_local
fi

sudo ./pishrink.sh build/*.img
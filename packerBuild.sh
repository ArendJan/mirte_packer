#!/bin/bash
set -xe

REMOVE_GIT_LOCAL=false
if [ ! -d git_local ]; then
REMOVE_GIT_LOCAL=true
echo "Downloading git stuff"
mkdir git_local
fi
ls git_local > existingFiles.txt
cd git_local
# Download all Mirte repositories
vcs import < ../repos.yaml --workers 1 || true
cd ..

PACKER_CONFIG_DIR=$HOME sudo -E $(which packer) build .  | tee log.txt

OLD_GLOB=$GLOBIGNORE
GLOBIGNORE=$(paste -s -d : existingFiles.txt)
cd git_local
rm -rf *
cd ..
if $REMOVE_GIT_LOCAL; then
rm -rf git_local
fi
GLOBIGNORE=$OLD_GLOB

sudo ./pishrink.sh build/*.img || true
rm existingFiles.txt
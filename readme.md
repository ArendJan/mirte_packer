# Build Mirte image using Packer

## Install
run sudo ./packerInstall.sh to download stuff

## Build
Run sudo ./packerBuild.sh to build the image. Will take some time
Put your local files in git_local/ and they will be copied
edit settings.sh to select features and extra scripts

## Shell to edit
run ./shell.sh \<img file> (Docker required) and it should present you with a shell in the image at the mirte home directory. Might take some time to build the docker image the first time


# TODOS:
- npm prebuilt
- store log on image
- rename image to date
- fix breaking qemu
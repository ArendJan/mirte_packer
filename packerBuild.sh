#!/bin/bash
set -xe
set -o pipefail

if [ "$EUID" -eq 0 ]; then
	echo "Please don't run as root"
	exit
fi
only_flags=""
if (($# > 0)); then
	only_flags="--only arm-image.$1"
fi

mkdir git_local || true
mkdir workdir || true
mkdir logs || true
touch logs/current_log.txt
sudo packer build $only_flags build.pkr.hcl | tee logs/log-"$(date +"%Y-%m-%d %H:%M:%S")".txt logs/current_log.txt

if (($# > 0)); then
	./scripts/finalize.sh "$(realpath "./workdir/$1.img")"
else
	
	./scripts/finalize.sh $(realpath "./workdir/mirteopi.img") &
	./scripts/finalize.sh $(realpath "./workdir/mirteopi2.img") &
	./scripts/finalize.sh $(realpath "./workdir/mirteopi3b.img") &
	wait
fi
set +o pipefail

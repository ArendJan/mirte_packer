#!/bin/bash
set -xe
set -o pipefail

only_flags=""
if (($# > 0)); then
	only_flags="--only arm-image.$1"
fi

mkdir git_local || true
mkdir workdir || true
mkdir logs || true
mkdir build || true
touch logs/current_log.txt
sudo packer build $only_flags build.pkr.hcl | tee logs/log-"$(date +"%Y-%m-%d %H:%M:%S")".txt logs/current_log.txt

. ./scripts/finalize.sh
if (($# > 0)); then
	finalize "$(realpath "./workdir/$1.img")"
else
	finalize $(realpath "./workdir/mirteopi2.img") &
	finalize $(realpath "./workdir/mirteopi.img") &
	wait
fi
set +o pipefail

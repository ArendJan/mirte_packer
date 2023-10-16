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


. ./scripts/finalize.sh
if (($# > 0)); then
	finalize "$1"
else
	finalize "mirteopi2" &
	finalize "mirteopi" &
	wait
fi
set +o pipefail

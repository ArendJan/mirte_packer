#!/bin/bash
rm -rf /tmp/artifacts || true
mkdir /tmp/artifacts || true
act --container-options="-v /dev:/dev -v /proc:/proc --privileged"  --artifact-server-path /tmp/artifacts
mkdir artifacts || true
cp -r /tmp/artifacts/* ./artifacts
# somehow the files get an extra __ at the end
find ./artifacts -name "*.gz__" -exec sh -c 'mv "$1" "${1%.gz__}.gz"' _ {} \;
find ./artifacts -name "*.gz" -exec sh -c 'gunzip "$1"' _ {} \;

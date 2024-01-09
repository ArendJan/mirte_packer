mkdir /tmp/artifacts || true
act --container-options="-v /dev:/dev -v /proc:/proc --privileged"  --artifact-server-path /tmp/artifacts
mkdir artifacts || true
cp /tmp/artifacts/* ./artifacts
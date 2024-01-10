rm -rf /tmp/artifacts || true
mkdir /tmp/artifacts || true
act --container-options="-v /dev:/dev -v /proc:/proc --privileged"  --artifact-server-path /tmp/artifacts
mkdir artifacts || true
cp -r /tmp/artifacts/* ./artifacts
# somehow the files get an extra __ at the end
for file in ./artifacts/**.img.xz.gz__; do
    mv -- "$file" "${file%.img.xz.gz__}.img.xz.gz"
done

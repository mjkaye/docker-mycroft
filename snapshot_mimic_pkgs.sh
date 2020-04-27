#!/usr/bin/env bash

REPO=https://forslund.github.io/mycroft-desktop-repo/
PACKAGE_LISTS=dists/bionic/main/binary-{amd64,armhf,arm64}/Packages
POOL=pool/main/m/mimic/
LOCAL_DIR=packages/

for deb in $(curl -s ${REPO}${PACKAGE_LISTS} | sed -nr 's/.*(mimic_.*\.deb)/\1/p'); do
    curl ${REPO}${POOL}${deb} --create-dirs --output ${LOCAL_DIR}${deb};
done

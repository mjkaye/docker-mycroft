#!/usr/bin/env bash

# Copyright 2017 Mycroft AI Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# exit on any error
set -Ee

MIMIC_DIR=/opt/mycroft/mimic
CORES=$(nproc)
MIMIC_VERSION=1.2.0.2

apt-get -y install gcc make pkg-config automake libtool libicu-dev libpcre2-dev libasound2-dev

# download and install mimic
if [ ! -d ${MIMIC_DIR} ] ; then
    git clone --branch ${MIMIC_VERSION} https://github.com/MycroftAI/mimic.git --depth=1
    cd ${MIMIC_DIR}
    ./autogen.sh
    ./configure --with-audio=alsa --enable-shared --prefix="$(pwd)"
    make -j${CORES}
    make install
else
    # ensure mimic is up to date
    cd ${MIMIC_DIR}
    make clean 2> /dev/null || true
    git remote add all-branches https://github.com/mycroftai/mimic/ 2> /dev/null || true
    git fetch --all --tags --prune
    git checkout tags/${MIMIC_VERSION}
    ./autogen.sh
    ./configure --with-audio=alsa --enable-shared --prefix="$(pwd)"
    make clean
    make -j${CORES}
    make install
fi

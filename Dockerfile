ARG BASE_IMAGE_PREFIX
FROM ${BASE_IMAGE_PREFIX}debian:buster-slim

# mimic_pkg defaults to installing the latest version available from the remote
# repo. To make sure you install the version that accompanied this Mycroft AI
# release, uncomment the version that matches your architecture.
ARG mimic_pkg=mimic
# ARG mimic_pkg=mimic=1.3.0.0
# ARG mimic_pkg=mimic=1.3.0.1
# ARG mimic_pkg=mimic=1.2.0.2+1559651054

ARG host_locale=en_US.UTF-8

ARG mycroft_core_tag=release/v20.8.1

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

# Install Server Dependencies for Mycroft
RUN set -x \
        && apt-get update \
	&& apt-get -y install \
	git \
	locales \
	procps \
	python3 \
	python3-pip \
        python3-dev \
	sudo \
        build-essential \
        cargo \
        bison \
        curl \
        flac \
        jq \
        libfann-dev \
        libffi-dev \
        libjpeg-dev \
        libssl-dev \
        libtool \
        mpg123 \
        pkg-config \
        portaudio19-dev \
        pulseaudio \
        pulseaudio-utils \
        python3-setuptools \
	swig \
	zlib1g-dev \
        # Cryptography
	&& curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y \
        && pip3 install --upgrade pip \
        && pip3 install cryptography --no-binary cryptography \
        # Checkout Mycroft
	&& git clone https://github.com/MycroftAI/mycroft-core.git /opt/mycroft --branch=$mycroft_core_tag \
	&& cd /opt/mycroft \
	&& mkdir /opt/mycroft/skills \
	&& pip3 install --upgrade --ignore-installed pyxdg \
	-r /opt/mycroft/requirements/requirements.txt

RUN curl https://forslund.github.io/mycroft-desktop-repo/mycroft-desktop.gpg.key \
	| apt-key add - 2> /dev/null \
	&& echo "deb http://forslund.github.io/mycroft-desktop-repo bionic main" \
	> /etc/apt/sources.list.d/mycroft-desktop.list \
	&& apt-get update \
	&& apt-get install -y $mimic_pkg \
	&& apt-get -y autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the locale
RUN sed -i -e 's/# \('"$host_locale"' .*\)/\1/' /etc/locale.gen \
        && dpkg-reconfigure --frontend=noninteractive locales \
	&& update-locale LANG=$host_locale

WORKDIR /opt/mycroft
COPY startup.sh /opt/mycroft
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai

RUN echo "PATH=$PATH:/opt/mycroft/bin" >> $HOME/.bashrc \
	&& ln -s /usr/bin/python3 /usr/bin/python \
	# We don't use virtualenv any more. Make stub for scripts that try to.
	&& echo "" > /opt/mycroft/venv-activate.sh \
	&& chmod +x /opt/mycroft/start-mycroft.sh \
	&& chmod +x /opt/mycroft/startup.sh \
        && chmod +x /opt/mycroft/bin/mycroft-cli-client \
        && chmod +x /opt/mycroft/bin/mycroft-help \
        && chmod +x /opt/mycroft/bin/mycroft-mic-test \
        && chmod +x /opt/mycroft/bin/mycroft-msk \
        && chmod +x /opt/mycroft/bin/mycroft-msm \
        && chmod +x /opt/mycroft/bin/mycroft-pip \
        && chmod +x /opt/mycroft/bin/mycroft-say-to \
        && chmod +x /opt/mycroft/bin/mycroft-skill-testrunner \
	&& chmod +x /opt/mycroft/bin/mycroft-speak

RUN mkdir /var/log/mycroft/ \
	&& chmod 777 /var/log/mycroft/

#Store a fingerprint of setup
RUN md5sum /opt/mycroft/requirements/requirements.txt > /opt/mycroft/.installed

EXPOSE 8181

ENTRYPOINT "/opt/mycroft/startup.sh"

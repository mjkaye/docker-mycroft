# see hooks/post_checkout
ARG ARCH

FROM alpine AS builder

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-${ARCH}.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

ARG BASE_IMAGE_PREFIX
FROM ${BASE_IMAGE_PREFIX}debian:buster-slim


# HACK: don't fail when no qemu binary provided
COPY --from=builder qemu-${ARCH}-static* /usr/bin

ARG host_locale=en_US.UTF-8
ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

# Install Server Dependencies for Mycroft
RUN set -x \
    	&& echo "==================================================================" \
	&& echo "Building Mycroft-AI:" \
	&& echo "  arch:\t${ARCH}" \
	&& echo "  base_image_prefix:\t${BASE_IMAGE_PREFIX}" \
    	&& echo "==================================================================" \
	&& apt-get update \
	&& apt-get -y install git python3 python3-pip locales sudo procps \
	&& pip3 install future msm \
	# Checkout Mycroft
	&& git clone https://github.com/MycroftAI/mycroft-core.git /opt/mycroft \
	&& cd /opt/mycroft \
	&& mkdir /opt/mycroft/skills \
	# git fetch && git checkout dev && \ this branch is now merged to master
	&& CI=true /opt/mycroft/./dev_setup.sh --allow-root -sm \
	&& mkdir /opt/mycroft/scripts/logs \
	&& touch /opt/mycroft/scripts/logs/mycroft-bus.log \
	&& touch /opt/mycroft/scripts/logs/mycroft-voice.log \
	&& touch /opt/mycroft/scripts/logs/mycroft-skills.log \
	&& touch /opt/mycroft/scripts/logs/mycroft-audio.log

# Set the locale
RUN sed -i -e 's/# \('"$host_locale"' .*\)/\1/' /etc/locale.gen \
    	&& dpkg-reconfigure --frontend=noninteractive locales \
	&& update-locale LANG=$host_locale

WORKDIR /opt/mycroft
COPY startup.sh /opt/mycroft
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai

RUN echo "PATH=$PATH:/opt/mycroft/bin" >> $HOME/.bashrc \
        && echo "source /opt/mycroft/.venv/bin/activate" >> $HOME/.bashrc

RUN chmod +x /opt/mycroft/start-mycroft.sh \
	&& chmod +x /opt/mycroft/startup.sh

COPY install-mimic-arm.sh /opt/mycroft/scripts
RUN chmod +x /opt/mycroft/scripts/install-mimic-arm.sh \
    	&& /opt/mycroft/scripts/install-mimic-arm.sh

RUN set -x \
    	&& apt-get -y autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8181

ENTRYPOINT "/opt/mycroft/startup.sh"

# Mycroft AI Docker image running on slimified Debian Linux #

[![Build Status](https://cloud.drone.io/api/badges/mjkaye/docker-mycroft-debian-slim/status.svg)](https://cloud.drone.io/mjkaye/docker-mycroft-debian-slim)

[![Docker pulls](https://img.shields.io/docker/pulls/mjkaye/mycroft-debian-slim.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/mjkaye/mycroft-debian-slim)

[![Mycroft AI version](https://img.shields.io/badge/Mycroft%20AI%20version-20.2.3-blue.svg?style=for-the-badge)](https://mycroft.ai/)
[![Debian slim version](https://img.shields.io/badge/Debian%20slim%20version-buster-blue.svg?style=for-the-badge)](https://www.debian.org/)

[![Github repository](https://img.shields.io/static/v1.svg?style=for-the-badge&color=blue&label=source%20code&message=docker-mycroft-debian-slim&logo=github&logoColor=FFFFFF)](https://www.github.com/mjkaye/docker-mycroft-debian-slim)

## What is Mycroft AI? ##

[Mycroft AI](https://mycroft.ai/) is the world's first Free and Open Source (FOSS) voice assistant. You can buy a Mycroft smart speaker from [the shop](https://mycroft.ai/shop/), get hold of a [DIY version](https://hellochatterbox.com/), or run the software on a device of your choosing--desktop computer, Single Board Computer (including the Raspberry Pi), etc. This Docker image is one such way to do so.

Control technology with your voice.

## What is Debian slim? ##

Debian is an operating system that is comprised mostly of Free and Open Source Software. It is one of the most popular Linux distributions and forms the basis of many others.

Debian slim excludes files that are not often required within a container, such as documentation. This base image is around 25MiB.

## Supported architectures ##

| Architecture  | Tag          |
| ---           | ---          |
| amd64/x86_64  | latest-amd64 |
| arm32v7/armhf | latest-arm   |
| aarch64/arm64 | latest-arm64 |

## How to use this image ##

```bash
docker run -d \
  --name mycroft
  -e PULSE_SERVER=unix:/run/user/0/pulse/native \
  -p 8181:8181 \
  -v ${XDG_RUNTIME_DIR}/pulse/native:/run/user/0/pulse/native \
  -v ~/.config/pulse/cookie:/root/.config/pulse/cookie \
  -v config:/root/.mycroft \
  -v skills:/opt/mycroft/skills \
  --restart unless-stopped
  mjkaye/mycroft-debian-slim
```

### Parameters ###

Container images are configured using parameters passed at run-time (such as those above). These parameters are separated by a colon and indicate `<host>:<container>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080`.

| Parameter                 | Function                                                                                                                |
| ---                       | ---                                                                                                                     |
| `-p 8181:8181`            | grants LAN access to Mycroft (e.g. to send notifications); optional                                                     |
| `-e PULSE_SERVER`         | access pulseaudio on the host; see pulse/native volume                                                                  |
| `-v :...pulse/native`     | shares ...pulse/native with the host                                                                                    |
| `-v :/root/.mycroft`      | persistent storage for configuration                                                                                    |
| `-v :/opt/mycroft/skills` | persistent storage for installed skills (so that they don't have to be reinstalled every time the container is started) |

### Pairing ###

If your audio is configured correctly, you should hear your Mycroft instance giving you a pairing code that you should use at https://home.mycroft.ai

If you don't have audio set up, you can see the pairing code by examining the logs:

```bash
docker logs mycroft | grep "Pairing code:"
```

### CLI access ###

Get access to the container CLI with:

```bash
docker exec -it mycroft /bin/bash
```

From the container's command prompt, start the CLI console with:

```bash
mycroft-cli-client
```

When the image starts, it installs all the requirements for the installed services. This takes some time and Mycroft is not ready until this process has finished.

## Support ##

 * [Mycroft AI documentation](https://mycroft-ai.gitbook.io/docs/)
 * [Mycroft AI community](https://community.mycroft.ai/)
 * [report Mycroft AI bugs](https://github.com/MycroftAI/mycroft-core/issues)
 * [report bugs related to this Docker image](https://github.com/mjkaye/docker-mycroft-debian-slim/issues)
 * [contribute to Mycroft AI](https://mycroft.ai/contribute/)

## Donate ##

|                                                                                                                                                                                                                                                               |                                                                                                 |
| ---                                                                                                                                                                                                                                                           | ---                                                                                             |
| [![Donate using Donorbox](https://img.shields.io/badge/usd,gbp,eur-265B79?logo=shopify&style=for-the-badge)](https://donorbox.org/docker-images)                                                                                                              |                                                                                                 |
| [![Donate using Bitcoin](https://img.shields.io/badge/bitcoin-265B79?logo=bitcoin&style=for-the-badge)](https://www.freeformatter.com/qr-code?w=350&h=350&e=Q&c=bc1q2acfmcwrqc9pzttqgwn6nd0t5cncleue6ukfrs)                                                   | bc1q2acfmcwrqc9pzttqgwn6nd0t5cncleue6ukfrs                                                      |
| [![Donate using Ethereum](https://img.shields.io/badge/ethereum-265B79?logo=ethereum&style=for-the-badge)](https://www.freeformatter.com/qr-code?w=350&h=350&e=Q&c=0x95ab6d374ef0d3a84bb7c767cdf6c77b3b170ba2)                                                | 0x95ab6d374ef0d3a84bb7c767cdf6c77b3b170ba2                                                      |
| [![Donate using Dash](https://img.shields.io/badge/dash-265B79?logo=dash&style=for-the-badge)](https://www.freeformatter.com/qr-code?w=350&h=350&e=Q&c=XxVEjb1uYFnBGLm59eytUHBDWAYTHeyrET)                                                                    | XxVEjb1uYFnBGLm59eytUHBDWAYTHeyrET                                                              |
| [![Donate using Monero](https://img.shields.io/badge/monero-265B79?logo=monero&style=for-the-badge)](https://www.freeformatter.com/qr-code?w=350&h=350&e=Q&c=46PNRCAb9oq244vALWaRX5GzWJHtkZEqKav3BJBFBSsrPbL44A5PwEa4RVkS5xMzRtT2MUjhX9QhibiFjjBbdADa5V3TXzJ) | 46PNRCAb9oq244vALWaRX5GzWJHtkZEqKav3BJBFBSsrPbL44A5PwEa4RVkS5xMzRtT2MUjhX9QhibiFjjBbdADa5V3TXzJ |
| [![Donate using Groestlcoin](https://img.shields.io/badge/groestlcoin-265B79?&style=for-the-badge)](https://www.freeformatter.com/qr-code?w=350&h=350&e=Q&c=grs1q4gu2xfg8q448tlajg8grqkrlw9rjvuz29vctmj)                                                      | grs1q4gu2xfg8q448tlajg8grqkrlw9rjvuz29vctmj                                                     |

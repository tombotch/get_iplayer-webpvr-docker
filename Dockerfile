FROM ubuntu:rolling
# override with --build-arg <varname>=<value> during docker build
ARG GET_IPLAYER_VERSION=v3.34
ARG GUI_PORT=1935

LABEL org.opencontainers.image.authors = "tombotch"
LABEL org.opencontainers.image.source = "https://github.com/tombotch/get_iplayer-webpvr-docker"
LABEL org.opencontainers.image.description = "get_iplayer Web PVR"
LABEL org.opencontainers.image.licenses = "GPL-3.0"
LABEL org.opencontainers.image.version = ${GET_IPLAYER_VERSION}

EXPOSE ${GUI_PORT}/tcp

WORKDIR /tmp
RUN ["apt-get", "update"]
RUN ["apt-get", "upgrade", "-y"]
RUN ["apt-get", "install", "-y", "libwww-perl", "liblwp-protocol-https-perl", "libmojolicious-perl", "libxml-libxml-perl", "libcgi-pm-perl", "atomicparsley", "ffmpeg", "wget"]

# fetch get_iplayer
ADD --chmod=755 https://raw.githubusercontent.com/get-iplayer/get_iplayer/${GET_IPLAYER_VERSION}/get_iplayer /usr/local/bin
ADD --chmod=755 https://raw.githubusercontent.com/get-iplayer/get_iplayer/${GET_IPLAYER_VERSION}/get_iplayer.cgi /usr/local/bin

# set configuration
ENV GETIPLAYER_PROFILE=/config
RUN ["get_iplayer", "--prefs-add", "--output", "/data"]

#  ENTRYPOINT cannot use ARG values directly so we have to copy it to an ENV to utilize it
ENV GUI_PORT=${GUI_PORT}
ENTRYPOINT get_iplayer.cgi --listen 0.0.0.0 --port ${GUI_PORT}

FROM debian
EXPOSE 1935
WORKDIR /tmp
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "libwww-perl", "liblwp-protocol-https-perl", "libmojolicious-perl", "libxml-libxml-perl", "libcgi-pm-perl", "atomicparsley", "ffmpeg", "wget"]
RUN ["wget", "https://raw.githubusercontent.com/get-iplayer/get_iplayer/v3.28/get_iplayer"]
RUN ["install", "-m", "755", "./get_iplayer", "/usr/local/bin"]
RUN ["mkdir", "-p", "/var/lib/get_iplayer"]
RUN ["get_iplayer", "--prefs-add", "--output", "/var/lib/get_iplayer"]
RUN ["wget", "https://raw.githubusercontent.com/get-iplayer/get_iplayer/v3.28/get_iplayer.cgi"]
RUN ["install", "-m", "755", "./get_iplayer.cgi", "/usr/local/bin"]
ENTRYPOINT ["get_iplayer.cgi", "--listen", "0.0.0.0", "--port", "1935"]

FROM ubuntu:18.04

ARG DEBIAN_FRONTEND="noninteractive"

RUN set -ex; \
    apt-get update && \
    apt-get -y install software-properties-common && \
    add-apt-repository -u ppa:deluge-team/stable && \
    apt-get update && apt-get -y install dumb-init iputils-ping dnsutils bash jq net-tools openvpn curl ufw deluged deluge-console deluge-web p7zip-full unrar unzip && \
    echo "Cleanup"; \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
    echo "Adding user"; \
    groupmod -g 1000 users && \
    useradd -u 911 -U -d /config -s /bin/false abc && \
    usermod -G users abc

# Add configuration and scripts
COPY root/ /

ENV OPENVPN_USERNAME=**None** \
    OPENVPN_PASSWORD=**None** \
    OPENVPN_PROVIDER=**None** \
    GLOBAL_APPLY_PERMISSIONS=true \
    TZ=Europe/Berlin \
    DELUGE_WEB_PORT=8112 \
    DELUGE_DEAMON_PORT=58846 \
    DELUGE_DOWNLOAD_DIR=/download/completed \
    DELUGE_INCOMPLETE_DIR=/download/incomplete \
    DELUGE_TORRENT_DIR=/download/torrents \
    DELUGE_WATCH_DIR=/download/watch \
    CREATE_TUN_DEVICE=true \
    ENABLE_UFW=false \
    UFW_ALLOW_GW_NET=false \
    UFW_EXTRA_PORTS= \
    UFW_DISABLE_IPTABLES_REJECT=false \
    PUID= \
    PGID= \
    UMASK=022 \
    PEER_DNS=true \
    PEER_DNS_PIN_ROUTES=true \
    DROP_DEFAULT_ROUTE= \
    HEALTH_CHECK_HOST=google.com \
    LOG_TO_STDOUT=false \
    DELUGE_LISTEN_PORT_LOW=53394 \
    DELUGE_LISTEN_PORT_HIGH=53404 \
    DELUGE_OUTGOING_PORT_LOW=63394 \
    DELUGE_OUTGOING_PORT_HIGH=63404

HEALTHCHECK --interval=1m CMD /etc/scripts/healthcheck.sh

# Deluge Deamon and web
EXPOSE 8112 58846

CMD ["dumb-init", "/etc/openvpn/init.sh"]

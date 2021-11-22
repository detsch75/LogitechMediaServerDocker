FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PREFIX_DIR=/srv
ENV SQUEEZE_VOL=${PREFIX_DIR}/squeezebox

RUN mkdir -p ${PREFIX_DIR} && \
    mkdir -p ${SQUEEZE_VOL}

WORKDIR ${PREFIX_DIR}

COPY logitechmediaserver_8.2.0_amd64.deb ${PREFIX_DIR}/logitechmediaserver.deb

RUN apt-get update && \
    apt-get upgrade && \
    apt-get -y dist-upgrade && \
    apt-get install -yq apt-utils locales iproute2 perl libio-socket-ssl-perl ca-certificates && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    dpkg -i ${PREFIX_DIR}/logitechmediaserver.deb && \
    rm ${PREFIX_DIR}/logitechmediaserver.deb && \
    apt -y autoremove && \
    apt-get autoclean && \
    apt-get clean && \
    rm -rf /var/lib/apt-lists/*

ENV LANG=en_US.UTF-8

COPY entrypoint.sh ${PREFIX_DIR}/entrypoint.sh
COPY start-squeezebox.sh ${PREFIX_DIR}/start-squeezebox.sh
RUN chmod 755 ${PREFIX_DIR}/entrypoint.sh ${PREFIX_DIR}/start-squeezebox.sh

RUN chown squeezeboxserver:nogroup ${SQUEEZE_VOL}

USER squeezeboxserver

VOLUME $SQUEEZE_VOL
EXPOSE 3483 3483/udp 9000 9090
ENTRYPOINT ["/srv/entrypoint.sh"]
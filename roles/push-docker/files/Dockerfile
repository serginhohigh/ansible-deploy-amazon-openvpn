FROM alpine:latest

RUN apk update && apk upgrade && apk add --update \
        bash \
        openvpn \
        openssl \
        git \
        haveged \
        expect \
        vim \
        netcat-openbsd


RUN mkdir /var/log/openvpn && \
        touch /var/log/openvpn/openvpn-status.log && \
        touch /var/log/openvpn/openvpn.log

RUN rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/*

VOLUME /etc/openvpn

EXPOSE 443/tcp

CMD ["openvpn_up"]

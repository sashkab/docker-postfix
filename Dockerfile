FROM alpine:3.9

LABEL \
    maintainer="github@compuix.com" \
    version="2019.02.15" \
    description="SMTP relay server for local subnets."

RUN set -xe \
    && addgroup -g 587 postfix && adduser -D -H -h /etc/postfix -g postfix -u 587 -G postfix postfix \
    && addgroup -g 465 postdrop && adduser -D -H -h /var/mail/domains -g postdrop -u 465 -G postdrop vmail \
    && apk add --no-cache bash ca-certificates libsasl cyrus-sasl-plain cyrus-sasl-login postfix rsyslog runit \
    && mkdir mkdir /etc/sasl2 \
    && touch /var/log/maillog \
    && postalias /etc/postfix/aliases \
    && sed -i -r -e 's/^#submission/submission/' /etc/postfix/master.cf \
    && chown root:root /var/spool/postfix /var/spool/postfix/pid \
    && echo -e "#!/bin/sh\n\nexec /sbin/runsvdir /etc/service\n" > /usr/sbin/runit_bootstrap && chmod +x /usr/sbin/runit_bootstrap

COPY service /etc/service
COPY rsyslog.conf /etc/rsyslog.conf
COPY ["header_checks", "dh512.pem", "dh2048.pem", "/etc/postfix/"]

RUN	chmod 644 /etc/postfix/dh*.pem /etc/postfix/header_checks

EXPOSE 25/tcp 587/tcp

STOPSIGNAL SIGKILL

ENTRYPOINT ["/usr/sbin/runit_bootstrap"]

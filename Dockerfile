FROM alpine:3.11

LABEL \
    maintainer="github@compuix.com" \
    version="2020.03.07" \
    description="SMTP relay server for local subnets."

RUN set -xe \
    && addgroup -g 587 postfix && adduser -D -H -h /etc/postfix -g postfix -u 587 -G postfix postfix \
    && addgroup -g 465 postdrop && adduser -D -H -h /var/mail/domains -g postdrop -u 465 -G postdrop vmail \
    && apk add --no-cache bash ca-certificates libsasl cyrus-sasl-plain cyrus-sasl-login postfix tzdata \
    && ln -sfn /usr/share/zoneinfo/America/New_York /etc/localtime \
    && touch /var/log/maillog \
    && postalias /etc/postfix/aliases \
    && sed -i -r -e 's/^#submission/submission/' /etc/postfix/master.cf \
    && chown root:root /var/spool/postfix /var/spool/postfix/pid

COPY ["header_checks", "dh512.pem", "dh2048.pem", "/etc/postfix/"]
COPY ["run_postfix", "/"]

RUN	chmod 644 /etc/postfix/dh*.pem /etc/postfix/header_checks \
    && chmod +x /run_postfix

EXPOSE 25/tcp 587/tcp

STOPSIGNAL SIGKILL

ENTRYPOINT ["/run_postfix"]
